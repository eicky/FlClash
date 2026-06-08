import 'package:dio/dio.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/panel_type.dart';
import 'package:fl_clash/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/panel_auth.g.dart';

@Riverpod(keepAlive: true)
class PanelAuthState extends _$PanelAuthState {
  @override
  PanelAuth? build() {
    // 异步从 SP 加载，但先返回 null
    _loadFromPrefs();
    return null;
  }

  Future<void> _loadFromPrefs() async {
    final auth = await preferences.getPanelAuth();
    if (auth != null && ref.mounted) {
      state = auth;
    }
  }

  /// WebView 登录成功后调用，保存完整认证状态
  Future<void> onLoginSuccess({
    required String serverUrl,
    required String authData,
    required String subscribeUrl,
    String? token,
    PanelUserInfo? userInfo,
    PanelType panelType = PanelType.xboard,
  }) async {
    final auth = PanelAuth(
      serverUrl: serverUrl,
      authData: authData,
      token: token,
      subscribeUrl: subscribeUrl,
      userInfo: userInfo,
      panelType: panelType,
    );
    state = auth;
    await preferences.savePanelAuth(auth);
  }

  /// 更新用户信息（订阅刷新后）
  Future<void> updateUserInfo(PanelUserInfo userInfo) async {
    if (state == null) return;
    final updated = state!.copyWith(userInfo: userInfo);
    state = updated;
    await preferences.savePanelAuth(updated);
  }

  /// 退出登录
  Future<void> logout() async {
    state = null;
    await preferences.clearPanelAuth();
  }

  /// 检查登录状态是否有效
  Future<bool> checkLoginStatus() async {
    final auth = state;
    if (auth?.authData == null) return false;
    try {
      final dio = Dio();
      final response = await dio.get<Map<String, dynamic>>(
        '${auth!.serverUrl}/api/v1/user/checkLogin',
        options: Options(headers: {'Authorization': auth.authData}),
      );
      final data = response.data;
      return data?['status'] == 'success' &&
          data?['data']?['is_login'] == true;
    } catch (_) {
      return false;
    }
  }
}
