import 'dart:convert';

import 'package:fl_clash/enum/panel_type.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView JS Bridge 通信封装
/// 负责: 加载 JS 脚本 → 接收 JS channel 消息 → 解析数据 → 回调 Flutter
class PanelBridge {
  final PanelType panelType;
  final String serverUrl;
  final WebViewController controller;
  final void Function(PanelAuth auth) onLoginSuccess;
  final void Function(String message) onError;
  final VoidCallback? onBridgeReady;

  PanelBridge({
    required this.panelType,
    required this.serverUrl,
    required this.controller,
    required this.onLoginSuccess,
    required this.onError,
    this.onBridgeReady,
  });

  /// 初始化 JS Bridge channel 和页面加载
  void setup() {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlClashBridge',
        onMessageReceived: _handleMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            // 页面加载完成后注入 bridge JS
            _injectBridgeJs();
          },
        ),
      )
      ..loadRequest(Uri.parse('$serverUrl${panelType.loginPath}'));
  }

  /// 注入面板对应的 bridge JS 脚本
  Future<void> _injectBridgeJs() async {
    try {
      final js = await rootBundle.loadString(
        'assets/js/${panelType.jsAssetPath}',
      );
      await controller.runJavaScript(js);
    } catch (e) {
      onError('Failed to inject bridge JS: $e');
    }
  }

  /// 处理从 JS channel 收到的消息
  void _handleMessage(JavaScriptMessage message) {
    try {
      final json = jsonDecode(message.message) as Map<String, dynamic>;
      final type = json['type'] as String?;
      final data = json['data'] as Map<String, dynamic>? ?? {};

      switch (type) {
        case 'bridge_ready':
          onBridgeReady?.call();
          break;
        case 'login_success':
          _handleLoginSuccess(data);
          break;
        case 'error':
          onError(data['message'] as String? ?? 'Unknown error');
          break;
        case 'timeout':
          onError('登录超时，请重试');
          break;
      }
    } catch (e) {
      onError('Bridge message parse error: $e');
    }
  }

  /// 解析登录成功数据并回调
  void _handleLoginSuccess(Map<String, dynamic> data) {
    final userInfoRaw = data['user_info'] as Map<String, dynamic>? ?? {};
    final userInfo = PanelUserInfo(
      email: userInfoRaw['email'] as String?,
      upload: userInfoRaw['upload'] as int? ?? 0,
      download: userInfoRaw['download'] as int? ?? 0,
      transferEnable: userInfoRaw['transfer_enable'] as int? ?? 0,
      expiredAt: userInfoRaw['expired_at'] as int?,
      planName: userInfoRaw['plan_name'] as String?,
      deviceLimit: userInfoRaw['device_limit'] as int?,
    );

    final auth = PanelAuth(
      serverUrl: serverUrl,
      authData: data['auth_data'] as String?,
      token: data['token'] as String?,
      subscribeUrl: data['subscribe_url'] as String?,
      userInfo: userInfo,
      panelType: panelType,
    );

    onLoginSuccess(auth);
  }
}
