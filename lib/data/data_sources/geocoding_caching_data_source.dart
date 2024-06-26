import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/either.dart';
import '../../core/failure.dart';
import '../../domain/entities/city.dart';
import '../models/geographic_coordinates_model.dart';
import '../provider.dart';

@visibleForTesting
const geocodingCachePrefsKey = 'geocodingCache';

class _Cache {
  _Cache(this.map);

  factory _Cache.fromJson(Map<String, dynamic> json) =>
      _Cache(json.map((cityName, cacheItemJson) => MapEntry(
            City(name: cityName),
            _CacheItem.fromJson(cacheItemJson as Map<String, dynamic>),
          )));
  final Map<City, _CacheItem> map;
  Map<String, dynamic> toJson() =>
      map.map((city, cacheItem) => MapEntry(city.name, cacheItem.toJson()));
}

class _CacheItem extends Equatable {
  const _CacheItem({required this.date, required this.coordinates});

  factory _CacheItem.fromJson(Map<String, dynamic> json) => _CacheItem(
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      coordinates: GeographicCoordinatesModel.fromLocalJson(
        json['coordinates'] as Map<String, dynamic>,
      ));
  final DateTime date;
  final GeographicCoordinatesModel coordinates;

  dynamic toJson() => {
        'date': date.millisecondsSinceEpoch,
        'coordinates': coordinates.toJson(),
      };
  @override
  List<Object?> get props => [date, coordinates];
}

class GeocodingCachingDataSource {
  GeocodingCachingDataSource._(this._prefs)
      : _cache = _prefs.containsKey(geocodingCachePrefsKey)
            ? _Cache.fromJson(
                Map.of(
                  jsonDecode(_prefs.getString(geocodingCachePrefsKey)!)
                      as Map<String, dynamic>,
                ),
              )
            : _Cache({});

  final SharedPreferences _prefs;
  final _Cache _cache;

  Future<void> _flushCache() =>
      _prefs.setString(geocodingCachePrefsKey, jsonEncode(_cache.toJson()));

  Future<Either<Failure, GeographicCoordinatesModel?>> getCachedCoordinates(
    City city, {
    @visibleForTesting Duration invalidationDuration = const Duration(days: 7),
  }) async {
    if (!_cache.map.containsKey(city)) {
      return const Right(null);
    }
    final item = _cache.map[city]!;

    if (DateTime.now().toUtc().difference(item.date) >= invalidationDuration) {
      _cache.map.remove(city);
      await _flushCache();
      return const Right(null);
    }
    return Right(item.coordinates);
  }

  Future<Either<Failure, void>> setCachedCoordinates(
    City city,
    GeographicCoordinatesModel coordinates,
  ) async {
    _cache.map[coordinates.city] = _cache.map[city] =
        _CacheItem(date: DateTime.now(), coordinates: coordinates);
    await _flushCache();
    return const Right(null);
  }
}

final geocodingCachingDataSourceProvider = Provider(
  (ref) => GeocodingCachingDataSource._(ref.watch(sharedPreferencesProvider)),
);
