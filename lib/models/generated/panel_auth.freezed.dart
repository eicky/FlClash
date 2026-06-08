// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../panel_auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PanelUserInfo {

 int get transferEnable; int get upload; int get download; int? get expiredAt; String? get planName; String? get email; int? get deviceLimit;
/// Create a copy of PanelUserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanelUserInfoCopyWith<PanelUserInfo> get copyWith => _$PanelUserInfoCopyWithImpl<PanelUserInfo>(this as PanelUserInfo, _$identity);

  /// Serializes this PanelUserInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanelUserInfo&&(identical(other.transferEnable, transferEnable) || other.transferEnable == transferEnable)&&(identical(other.upload, upload) || other.upload == upload)&&(identical(other.download, download) || other.download == download)&&(identical(other.expiredAt, expiredAt) || other.expiredAt == expiredAt)&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.email, email) || other.email == email)&&(identical(other.deviceLimit, deviceLimit) || other.deviceLimit == deviceLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transferEnable,upload,download,expiredAt,planName,email,deviceLimit);

@override
String toString() {
  return 'PanelUserInfo(transferEnable: $transferEnable, upload: $upload, download: $download, expiredAt: $expiredAt, planName: $planName, email: $email, deviceLimit: $deviceLimit)';
}


}

/// @nodoc
abstract mixin class $PanelUserInfoCopyWith<$Res>  {
  factory $PanelUserInfoCopyWith(PanelUserInfo value, $Res Function(PanelUserInfo) _then) = _$PanelUserInfoCopyWithImpl;
@useResult
$Res call({
 int transferEnable, int upload, int download, int? expiredAt, String? planName, String? email, int? deviceLimit
});




}
/// @nodoc
class _$PanelUserInfoCopyWithImpl<$Res>
    implements $PanelUserInfoCopyWith<$Res> {
  _$PanelUserInfoCopyWithImpl(this._self, this._then);

  final PanelUserInfo _self;
  final $Res Function(PanelUserInfo) _then;

/// Create a copy of PanelUserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transferEnable = null,Object? upload = null,Object? download = null,Object? expiredAt = freezed,Object? planName = freezed,Object? email = freezed,Object? deviceLimit = freezed,}) {
  return _then(_self.copyWith(
transferEnable: null == transferEnable ? _self.transferEnable : transferEnable // ignore: cast_nullable_to_non_nullable
as int,upload: null == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as int,download: null == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as int,expiredAt: freezed == expiredAt ? _self.expiredAt : expiredAt // ignore: cast_nullable_to_non_nullable
as int?,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,deviceLimit: freezed == deviceLimit ? _self.deviceLimit : deviceLimit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PanelUserInfo].
extension PanelUserInfoPatterns on PanelUserInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PanelUserInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PanelUserInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PanelUserInfo value)  $default,){
final _that = this;
switch (_that) {
case _PanelUserInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PanelUserInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PanelUserInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int transferEnable,  int upload,  int download,  int? expiredAt,  String? planName,  String? email,  int? deviceLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PanelUserInfo() when $default != null:
return $default(_that.transferEnable,_that.upload,_that.download,_that.expiredAt,_that.planName,_that.email,_that.deviceLimit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int transferEnable,  int upload,  int download,  int? expiredAt,  String? planName,  String? email,  int? deviceLimit)  $default,) {final _that = this;
switch (_that) {
case _PanelUserInfo():
return $default(_that.transferEnable,_that.upload,_that.download,_that.expiredAt,_that.planName,_that.email,_that.deviceLimit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int transferEnable,  int upload,  int download,  int? expiredAt,  String? planName,  String? email,  int? deviceLimit)?  $default,) {final _that = this;
switch (_that) {
case _PanelUserInfo() when $default != null:
return $default(_that.transferEnable,_that.upload,_that.download,_that.expiredAt,_that.planName,_that.email,_that.deviceLimit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PanelUserInfo implements PanelUserInfo {
  const _PanelUserInfo({this.transferEnable = 0, this.upload = 0, this.download = 0, this.expiredAt, this.planName, this.email, this.deviceLimit});
  factory _PanelUserInfo.fromJson(Map<String, dynamic> json) => _$PanelUserInfoFromJson(json);

@override@JsonKey() final  int transferEnable;
@override@JsonKey() final  int upload;
@override@JsonKey() final  int download;
@override final  int? expiredAt;
@override final  String? planName;
@override final  String? email;
@override final  int? deviceLimit;

/// Create a copy of PanelUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PanelUserInfoCopyWith<_PanelUserInfo> get copyWith => __$PanelUserInfoCopyWithImpl<_PanelUserInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PanelUserInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PanelUserInfo&&(identical(other.transferEnable, transferEnable) || other.transferEnable == transferEnable)&&(identical(other.upload, upload) || other.upload == upload)&&(identical(other.download, download) || other.download == download)&&(identical(other.expiredAt, expiredAt) || other.expiredAt == expiredAt)&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.email, email) || other.email == email)&&(identical(other.deviceLimit, deviceLimit) || other.deviceLimit == deviceLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transferEnable,upload,download,expiredAt,planName,email,deviceLimit);

@override
String toString() {
  return 'PanelUserInfo(transferEnable: $transferEnable, upload: $upload, download: $download, expiredAt: $expiredAt, planName: $planName, email: $email, deviceLimit: $deviceLimit)';
}


}

/// @nodoc
abstract mixin class _$PanelUserInfoCopyWith<$Res> implements $PanelUserInfoCopyWith<$Res> {
  factory _$PanelUserInfoCopyWith(_PanelUserInfo value, $Res Function(_PanelUserInfo) _then) = __$PanelUserInfoCopyWithImpl;
@override @useResult
$Res call({
 int transferEnable, int upload, int download, int? expiredAt, String? planName, String? email, int? deviceLimit
});




}
/// @nodoc
class __$PanelUserInfoCopyWithImpl<$Res>
    implements _$PanelUserInfoCopyWith<$Res> {
  __$PanelUserInfoCopyWithImpl(this._self, this._then);

  final _PanelUserInfo _self;
  final $Res Function(_PanelUserInfo) _then;

/// Create a copy of PanelUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transferEnable = null,Object? upload = null,Object? download = null,Object? expiredAt = freezed,Object? planName = freezed,Object? email = freezed,Object? deviceLimit = freezed,}) {
  return _then(_PanelUserInfo(
transferEnable: null == transferEnable ? _self.transferEnable : transferEnable // ignore: cast_nullable_to_non_nullable
as int,upload: null == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as int,download: null == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as int,expiredAt: freezed == expiredAt ? _self.expiredAt : expiredAt // ignore: cast_nullable_to_non_nullable
as int?,planName: freezed == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,deviceLimit: freezed == deviceLimit ? _self.deviceLimit : deviceLimit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$PanelAuth {

 String get serverUrl; String? get authData; String? get token; String? get subscribeUrl; PanelUserInfo? get userInfo; PanelType get panelType;
/// Create a copy of PanelAuth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanelAuthCopyWith<PanelAuth> get copyWith => _$PanelAuthCopyWithImpl<PanelAuth>(this as PanelAuth, _$identity);

  /// Serializes this PanelAuth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanelAuth&&(identical(other.serverUrl, serverUrl) || other.serverUrl == serverUrl)&&(identical(other.authData, authData) || other.authData == authData)&&(identical(other.token, token) || other.token == token)&&(identical(other.subscribeUrl, subscribeUrl) || other.subscribeUrl == subscribeUrl)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.panelType, panelType) || other.panelType == panelType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serverUrl,authData,token,subscribeUrl,userInfo,panelType);

@override
String toString() {
  return 'PanelAuth(serverUrl: $serverUrl, authData: $authData, token: $token, subscribeUrl: $subscribeUrl, userInfo: $userInfo, panelType: $panelType)';
}


}

/// @nodoc
abstract mixin class $PanelAuthCopyWith<$Res>  {
  factory $PanelAuthCopyWith(PanelAuth value, $Res Function(PanelAuth) _then) = _$PanelAuthCopyWithImpl;
@useResult
$Res call({
 String serverUrl, String? authData, String? token, String? subscribeUrl, PanelUserInfo? userInfo, PanelType panelType
});


$PanelUserInfoCopyWith<$Res>? get userInfo;

}
/// @nodoc
class _$PanelAuthCopyWithImpl<$Res>
    implements $PanelAuthCopyWith<$Res> {
  _$PanelAuthCopyWithImpl(this._self, this._then);

  final PanelAuth _self;
  final $Res Function(PanelAuth) _then;

/// Create a copy of PanelAuth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serverUrl = null,Object? authData = freezed,Object? token = freezed,Object? subscribeUrl = freezed,Object? userInfo = freezed,Object? panelType = null,}) {
  return _then(_self.copyWith(
serverUrl: null == serverUrl ? _self.serverUrl : serverUrl // ignore: cast_nullable_to_non_nullable
as String,authData: freezed == authData ? _self.authData : authData // ignore: cast_nullable_to_non_nullable
as String?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,subscribeUrl: freezed == subscribeUrl ? _self.subscribeUrl : subscribeUrl // ignore: cast_nullable_to_non_nullable
as String?,userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as PanelUserInfo?,panelType: null == panelType ? _self.panelType : panelType // ignore: cast_nullable_to_non_nullable
as PanelType,
  ));
}
/// Create a copy of PanelAuth
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PanelUserInfoCopyWith<$Res>? get userInfo {
    if (_self.userInfo == null) {
    return null;
  }

  return $PanelUserInfoCopyWith<$Res>(_self.userInfo!, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [PanelAuth].
extension PanelAuthPatterns on PanelAuth {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PanelAuth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PanelAuth() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PanelAuth value)  $default,){
final _that = this;
switch (_that) {
case _PanelAuth():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PanelAuth value)?  $default,){
final _that = this;
switch (_that) {
case _PanelAuth() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serverUrl,  String? authData,  String? token,  String? subscribeUrl,  PanelUserInfo? userInfo,  PanelType panelType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PanelAuth() when $default != null:
return $default(_that.serverUrl,_that.authData,_that.token,_that.subscribeUrl,_that.userInfo,_that.panelType);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serverUrl,  String? authData,  String? token,  String? subscribeUrl,  PanelUserInfo? userInfo,  PanelType panelType)  $default,) {final _that = this;
switch (_that) {
case _PanelAuth():
return $default(_that.serverUrl,_that.authData,_that.token,_that.subscribeUrl,_that.userInfo,_that.panelType);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serverUrl,  String? authData,  String? token,  String? subscribeUrl,  PanelUserInfo? userInfo,  PanelType panelType)?  $default,) {final _that = this;
switch (_that) {
case _PanelAuth() when $default != null:
return $default(_that.serverUrl,_that.authData,_that.token,_that.subscribeUrl,_that.userInfo,_that.panelType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PanelAuth extends PanelAuth {
  const _PanelAuth({required this.serverUrl, this.authData, this.token, this.subscribeUrl, this.userInfo, this.panelType = PanelType.xboard}): super._();
  factory _PanelAuth.fromJson(Map<String, dynamic> json) => _$PanelAuthFromJson(json);

@override final  String serverUrl;
@override final  String? authData;
@override final  String? token;
@override final  String? subscribeUrl;
@override final  PanelUserInfo? userInfo;
@override@JsonKey() final  PanelType panelType;

/// Create a copy of PanelAuth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PanelAuthCopyWith<_PanelAuth> get copyWith => __$PanelAuthCopyWithImpl<_PanelAuth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PanelAuthToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PanelAuth&&(identical(other.serverUrl, serverUrl) || other.serverUrl == serverUrl)&&(identical(other.authData, authData) || other.authData == authData)&&(identical(other.token, token) || other.token == token)&&(identical(other.subscribeUrl, subscribeUrl) || other.subscribeUrl == subscribeUrl)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.panelType, panelType) || other.panelType == panelType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serverUrl,authData,token,subscribeUrl,userInfo,panelType);

@override
String toString() {
  return 'PanelAuth(serverUrl: $serverUrl, authData: $authData, token: $token, subscribeUrl: $subscribeUrl, userInfo: $userInfo, panelType: $panelType)';
}


}

/// @nodoc
abstract mixin class _$PanelAuthCopyWith<$Res> implements $PanelAuthCopyWith<$Res> {
  factory _$PanelAuthCopyWith(_PanelAuth value, $Res Function(_PanelAuth) _then) = __$PanelAuthCopyWithImpl;
@override @useResult
$Res call({
 String serverUrl, String? authData, String? token, String? subscribeUrl, PanelUserInfo? userInfo, PanelType panelType
});


@override $PanelUserInfoCopyWith<$Res>? get userInfo;

}
/// @nodoc
class __$PanelAuthCopyWithImpl<$Res>
    implements _$PanelAuthCopyWith<$Res> {
  __$PanelAuthCopyWithImpl(this._self, this._then);

  final _PanelAuth _self;
  final $Res Function(_PanelAuth) _then;

/// Create a copy of PanelAuth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serverUrl = null,Object? authData = freezed,Object? token = freezed,Object? subscribeUrl = freezed,Object? userInfo = freezed,Object? panelType = null,}) {
  return _then(_PanelAuth(
serverUrl: null == serverUrl ? _self.serverUrl : serverUrl // ignore: cast_nullable_to_non_nullable
as String,authData: freezed == authData ? _self.authData : authData // ignore: cast_nullable_to_non_nullable
as String?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,subscribeUrl: freezed == subscribeUrl ? _self.subscribeUrl : subscribeUrl // ignore: cast_nullable_to_non_nullable
as String?,userInfo: freezed == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as PanelUserInfo?,panelType: null == panelType ? _self.panelType : panelType // ignore: cast_nullable_to_non_nullable
as PanelType,
  ));
}

/// Create a copy of PanelAuth
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PanelUserInfoCopyWith<$Res>? get userInfo {
    if (_self.userInfo == null) {
    return null;
  }

  return $PanelUserInfoCopyWith<$Res>(_self.userInfo!, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}

// dart format on
