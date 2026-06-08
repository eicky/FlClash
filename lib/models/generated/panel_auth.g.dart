// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../panel_auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PanelUserInfo _$PanelUserInfoFromJson(Map<String, dynamic> json) =>
    _PanelUserInfo(
      transferEnable: (json['transferEnable'] as num?)?.toInt() ?? 0,
      upload: (json['upload'] as num?)?.toInt() ?? 0,
      download: (json['download'] as num?)?.toInt() ?? 0,
      expiredAt: (json['expiredAt'] as num?)?.toInt(),
      planName: json['planName'] as String?,
      email: json['email'] as String?,
      deviceLimit: (json['deviceLimit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PanelUserInfoToJson(_PanelUserInfo instance) =>
    <String, dynamic>{
      'transferEnable': instance.transferEnable,
      'upload': instance.upload,
      'download': instance.download,
      'expiredAt': instance.expiredAt,
      'planName': instance.planName,
      'email': instance.email,
      'deviceLimit': instance.deviceLimit,
    };

_PanelAuth _$PanelAuthFromJson(Map<String, dynamic> json) => _PanelAuth(
  serverUrl: json['serverUrl'] as String,
  authData: json['authData'] as String?,
  token: json['token'] as String?,
  subscribeUrl: json['subscribeUrl'] as String?,
  userInfo: json['userInfo'] == null
      ? null
      : PanelUserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
  panelType:
      $enumDecodeNullable(_$PanelTypeEnumMap, json['panelType']) ??
      PanelType.xboard,
);

Map<String, dynamic> _$PanelAuthToJson(_PanelAuth instance) =>
    <String, dynamic>{
      'serverUrl': instance.serverUrl,
      'authData': instance.authData,
      'token': instance.token,
      'subscribeUrl': instance.subscribeUrl,
      'userInfo': instance.userInfo,
      'panelType': _$PanelTypeEnumMap[instance.panelType]!,
    };

const _$PanelTypeEnumMap = {
  PanelType.xboard: 'xboard',
  PanelType.v2board: 'v2board',
  PanelType.sspanel: 'sspanel',
};
