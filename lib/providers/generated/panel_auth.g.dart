// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../panel_auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PanelAuthState)
final panelAuthStateProvider = PanelAuthStateProvider._();

final class PanelAuthStateProvider
    extends $NotifierProvider<PanelAuthState, PanelAuth?> {
  PanelAuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'panelAuthStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$panelAuthStateHash();

  @$internal
  @override
  PanelAuthState create() => PanelAuthState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PanelAuth? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PanelAuth?>(value),
    );
  }
}

String _$panelAuthStateHash() => r'92f44f16aaf0e6c762d254d1aa0d806c61092618';

abstract class _$PanelAuthState extends $Notifier<PanelAuth?> {
  PanelAuth? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PanelAuth?, PanelAuth?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PanelAuth?, PanelAuth?>,
              PanelAuth?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
