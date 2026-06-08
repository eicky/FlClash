import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/panel_type.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/login/panel_webview.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// 机场登录页 — 用户输入机场地址后打开 WebView 登录
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  String _normalizeUrl(String url) {
    var normalized = url.trim();
    if (normalized.isEmpty) return '';
    if (!normalized.startsWith('http://') &&
        !normalized.startsWith('https://')) {
      normalized = 'https://$normalized';
    }
    // 移除末尾斜杠
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }

  Future<void> _connectAirport() async {
    final url = _normalizeUrl(_urlController.text);
    if (url.isEmpty) {
      context.showNotifier('请输入机场地址');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final auth = await Navigator.of(context).push<PanelAuth>(
        MaterialPageRoute(
          builder: (_) => PanelWebView(
            serverUrl: url,
            panelType: PanelType.xboard,
          ),
        ),
      );

      if (auth != null) {
        // 保存认证状态
        await ref.read(panelAuthStateProvider.notifier).onLoginSuccess(
              serverUrl: auth.serverUrl,
              authData: auth.authData ?? '',
              subscribeUrl: auth.subscribeUrl ?? '',
              token: auth.token,
              userInfo: auth.userInfo,
              panelType: auth.panelType,
            );
        // 导入订阅
        if (auth.subscribeUrl != null && auth.subscribeUrl!.isNotEmpty) {
          globalState.container
              .read(profilesActionProvider.notifier)
              .addProfileFormURL(auth.subscribeUrl!);
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openRegister() async {
    final url = _normalizeUrl(_urlController.text);
    if (url.isEmpty) {
      context.showNotifier('请先输入机场地址');
      return;
    }
    final registerUrl = Uri.parse('$url/#/register');
    await launchUrl(registerUrl, mode: LaunchMode.externalApplication);
  }

  Future<void> _handleManualImport() async {
    // 复用现有的手动导入逻辑
    final appLocalizations = context.appLocalizations;
    final url = await globalState.showCommonDialog<String>(
      child: InputDialog(
        autovalidateMode: AutovalidateMode.onUnfocus,
        title: appLocalizations.importFromURL,
        labelText: appLocalizations.url,
        value: '',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return appLocalizations.emptyTip('').trim();
          }
          if (!value.isUrl) {
            return appLocalizations.urlTip('').trim();
          }
          return null;
        },
      ),
    );
    if (url != null) {
      globalState.container
          .read(profilesActionProvider.notifier)
          .addProfileFormURL(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Icon(
                  Icons.flight_takeoff,
                  size: 72,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'FlClash',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),

                // 机场地址输入
                TextField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '机场地址',
                    hintText: 'https://example.com',
                    prefixIcon: Icon(Icons.language),
                  ),
                  onSubmitted: (_) => _connectAirport(),
                ),
                const SizedBox(height: 24),

                // 连接机场按钮
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _connectAirport,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('连接机场'),
                  ),
                ),
                const SizedBox(height: 16),

                // 注册链接
                TextButton(
                  onPressed: _openRegister,
                  child: const Text('没有账号？点击注册'),
                ),
                const SizedBox(height: 32),

                // 手动导入分割线
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '或手动导入',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // 手动导入按钮
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _handleManualImport,
                    icon: const Icon(Icons.link),
                    label: Text(appLocalizations.url),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
