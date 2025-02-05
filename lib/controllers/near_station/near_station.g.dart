// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'near_station.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nearStationHash() => r'4a659ae421b705650ed76e721b076d48194f5f61';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$NearStation
    extends BuildlessAutoDisposeAsyncNotifier<NearStationState> {
  late final String latitude;
  late final String longitude;

  FutureOr<NearStationState> build({
    required String latitude,
    required String longitude,
  });
}

/// See also [NearStation].
@ProviderFor(NearStation)
const nearStationProvider = NearStationFamily();

/// See also [NearStation].
class NearStationFamily extends Family<AsyncValue<NearStationState>> {
  /// See also [NearStation].
  const NearStationFamily();

  /// See also [NearStation].
  NearStationProvider call({
    required String latitude,
    required String longitude,
  }) {
    return NearStationProvider(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  NearStationProvider getProviderOverride(
    covariant NearStationProvider provider,
  ) {
    return call(
      latitude: provider.latitude,
      longitude: provider.longitude,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nearStationProvider';
}

/// See also [NearStation].
class NearStationProvider extends AutoDisposeAsyncNotifierProviderImpl<
    NearStation, NearStationState> {
  /// See also [NearStation].
  NearStationProvider({
    required String latitude,
    required String longitude,
  }) : this._internal(
          () => NearStation()
            ..latitude = latitude
            ..longitude = longitude,
          from: nearStationProvider,
          name: r'nearStationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nearStationHash,
          dependencies: NearStationFamily._dependencies,
          allTransitiveDependencies:
              NearStationFamily._allTransitiveDependencies,
          latitude: latitude,
          longitude: longitude,
        );

  NearStationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.latitude,
    required this.longitude,
  }) : super.internal();

  final String latitude;
  final String longitude;

  @override
  FutureOr<NearStationState> runNotifierBuild(
    covariant NearStation notifier,
  ) {
    return notifier.build(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Override overrideWith(NearStation Function() create) {
    return ProviderOverride(
      origin: this,
      override: NearStationProvider._internal(
        () => create()
          ..latitude = latitude
          ..longitude = longitude,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<NearStation, NearStationState>
      createElement() {
    return _NearStationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearStationProvider &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, latitude.hashCode);
    hash = _SystemHash.combine(hash, longitude.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NearStationRef on AutoDisposeAsyncNotifierProviderRef<NearStationState> {
  /// The parameter `latitude` of this provider.
  String get latitude;

  /// The parameter `longitude` of this provider.
  String get longitude;
}

class _NearStationProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<NearStation,
        NearStationState> with NearStationRef {
  _NearStationProviderElement(super.provider);

  @override
  String get latitude => (origin as NearStationProvider).latitude;
  @override
  String get longitude => (origin as NearStationProvider).longitude;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
