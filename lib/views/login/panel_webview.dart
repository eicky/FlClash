import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/panel_type.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class PanelWebView extends StatefulWidget {
  final String serverUrl;
  final PanelType panelType;

  const PanelWebView({
    super.key,
    required this.serverUrl,
    required this.panelType,
  });

  @override
  State<PanelWebView> createState() => _PanelWebViewState();
}

class _PanelWebViewState extends State<PanelWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
            _onPageLoaded();
          },
          onWebResourceError: (error) {
            debugPrint(
              '[PanelWebView] resource error: ${error.description} '
              '(code=${error.errorCode})',
            );
          },
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      );

    _controller.addJavaScriptChannel(
      'FlClashBridge',
      onMessageReceived: _handleMessage,
    );

    final loginUrl = '${widget.serverUrl}${widget.panelType.loginPath}';
    debugPrint('[PanelWebView] loading: $loginUrl');
    _controller.loadRequest(Uri.parse(loginUrl));
  }

  /// Android 使用混合合成模式修复输入框无法输入的问题
  Widget _buildWebView() {
    if (Platform.isAndroid) {
      return WebViewWidget.fromPlatformCreationParams(
        params: AndroidWebViewWidgetCreationParams(
          controller: _controller.platform as AndroidWebViewController,
          displayWithHybridComposition: true,
        ),
      );
    }
    return WebViewWidget(controller: _controller);
  }

  Future<void> _onPageLoaded() async {
    await _injectCssFix();
    await _injectBridgeJs();
  }

  /// 注入 CSS 修复 Xboard 主题在 WebView 中的渲染问题
  Future<void> _injectCssFix() async {
    try {
      await _controller.runJavaScript('''
        (function() {
          document.body.style.backgroundColor = '#f5f5f5';
          document.body.style.color = '#333';
          var app = document.getElementById('app');
          if (app) {
            app.style.backgroundColor = '#f5f5f5';
            app.style.color = '#333';
            app.style.minHeight = '100vh';
          }
          document.body.style.opacity = '1';
          document.body.style.visibility = 'visible';
          document.body.style.display = 'block';
        })()
      ''');
    } catch (e) {
      debugPrint('[PanelWebView] inject CSS fix error: $e');
    }
  }

  Future<void> _injectBridgeJs() async {
    try {
      final js = await rootBundle.loadString(
        'assets/js/${widget.panelType.jsAssetPath}',
      );
      await _controller.runJavaScript(js);
    } catch (e) {
      debugPrint('[PanelWebView] inject bridge error: $e');
    }
  }

  void _handleMessage(JavaScriptMessage message) {
    debugPrint('[PanelWebView] bridge message: ${message.message}');
    try {
      final json = jsonDecode(message.message) as Map<String, dynamic>;
      final type = json['type'] as String?;
      final data = json['data'] as Map<String, dynamic>? ?? {};

      switch (type) {
        case 'login_success':
          _handleLoginSuccess(data);
          break;
        case 'error':
          _onError(data['message'] as String? ?? 'Unknown error');
          break;
        case 'timeout':
          _onError('登录超时，请重试');
          break;
      }
    } catch (e) {
      debugPrint('[PanelWebView] parse message error: $e');
    }
  }

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
      serverUrl: widget.serverUrl,
      authData: data['auth_data'] as String?,
      token: data['token'] as String?,
      subscribeUrl: data['subscribe_url'] as String?,
      userInfo: userInfo,
      panelType: widget.panelType,
    );

    if (mounted) {
      Navigator.of(context).pop(auth);
    }
  }

  void _onError(String message) {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _errorMsg = message;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getHost(widget.serverUrl),
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          _buildWebView(),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          if (_errorMsg != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMsg!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _errorMsg = null;
                        });
                        _controller.reload();
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getHost(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (_) {
      return url;
    }
  }
}
