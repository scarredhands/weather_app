import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

import '../../core/either.dart';
import '../../core/failure.dart';
import '../../core/functions.dart';
import '../../domain/entities/city.dart';
import '../models/full_weather_model.dart';
import '../repos/api_key_repo.dart';
import '../repos/geocoding_repo.dart';

class FullWeatherRemoteDataSource {
  FullWeatherRemoteDataSource(this._apiKeyRepo, this._geocodingRepo);
  final ApiKeyRepo _apiKeyRepo;
  final GeocodingRepo _geocodingRepo;

  Future<Either<Failure, FullWeatherModel>> getFullWeather(City city) async {
    final apiKeyModel = (await _apiKeyRepo.getApiKey()).fold((_) => null, id)!;

    final coordinates =
        (await _geocodingRepo.getCoordinates(city)).fold((_) => null, id)!;

    final response = await http.get(Uri(
        scheme: 'https',
        host: 'api.openweathermap.org',
        path: '/data/2.5/onecall',
        queryParameters: {
          'lon': coordinates.long.toString(),
          'lat': coordinates.lat.toString(),
          'appid': apiKeyModel.apiKey,
          'units': 'metric',
          'exclude': 'minutely,alerts',
        }));
    if (response.statusCode >= 200 && response.statusCode <= 226) {
      try {
        return Right(FullWeatherModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
          city: city,
        ));
      } on FormatException {
        return const Left(FailedToParseResponse());
      }
    } else if (response.statusCode == 503) {
      return const Left(ServerDown());
    } else if (response.statusCode == 404) {
      return Left(InvalidCityName(city.name));
    } else if (response.statusCode == 429) {
      return const Left(CallLimitExceeded());
    } else {
      return const Left(FailedToParseResponse());
    }
  }
}

final fullWeatherRemoteDataSourceProvider =
    Provider((ref) => FullWeatherRemoteDataSource(
          ref.watch(apiKeyRepoProvider),
          ref.watch(geocodingRepoProvider),
        ));
