import 'package:fl_clash/enum/panel_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/panel_auth.freezed.dart';
part 'generated/panel_auth.g.dart';

/// 机场面板用户信息（从 getSubscribe API 返回）
@freezed
abstract class PanelUserInfo with _$PanelUserInfo {
  const factory PanelUserInfo({
    @Default(0) int transferEnable,
    @Default(0) int upload,
    @Default(0) int download,
    int? expiredAt,
    String? planName,
    String? email,
    int? deviceLimit,
  }) = _PanelUserInfo;

  factory PanelUserInfo.fromJson(Map<String, Object?> json) =>
      _$PanelUserInfoFromJson(json);
}

/// 机场面板认证状态
@freezed
abstract class PanelAuth with _$PanelAuth {
  const factory PanelAuth({
    required String serverUrl,
    String? authData,
    String? token,
    String? subscribeUrl,
    PanelUserInfo? userInfo,
    @Default(PanelType.xboard) PanelType panelType,
  }) = _PanelAuth;

  factory PanelAuth.fromJson(Map<String, Object?> json) =>
      _$PanelAuthFromJson(json);

  const PanelAuth._();

  bool get isLoggedIn => authData != null && authData!.isNotEmpty;

  /// 已用流量 (bytes)
  int get usedBytes =>
      (userInfo?.upload ?? 0) + (userInfo?.download ?? 0);

  /// 总流量 (bytes)
  int get totalBytes => userInfo?.transferEnable ?? 0;

  /// 是否永不过期
  bool get isNeverExpire =>
      userInfo?.expiredAt == null;

  /// 到期时间的 DateTime（null 表示永不过期）
  DateTime? get expiredAtDate {
    final ts = userInfo?.expiredAt;
    if (ts == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ts * 1000);
  }
}
