import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

import '../../core/either.dart';
import '../../core/failure.dart';
import '../../core/functions.dart';
import '../../domain/entities/city.dart';
import '../models/geographic_coordinates_model.dart';
import '../repos/api_key_repo.dart';

class GeocodingRemoteDataSource {
  GeocodingRemoteDataSource(this._apiKeyRepo);
  final ApiKeyRepo _apiKeyRepo;

  Future<Either<Failure, GeographicCoordinatesModel>> getCoordinates(
    City city,
  ) async {
    final apiKeyModel = (await _apiKeyRepo.getApiKey()).fold((_) => null, id)!;

    final response = await http.get(Uri(
      scheme: 'https',
      host: 'api.openweathermap.org',
      path: '/geo/1.0/direct',
      queryParameters: {
        'q': city.name,
        'appid': apiKeyModel.apiKey,
        'limit': '1',
      },
    ));
    switch (response.statusCode) {
      case 503:
        return const Left(ServerDown());
      case 429:
        return const Left(CallLimitExceeded());
    }

    dynamic body;

    try {
      body = jsonDecode(response.body);
    } on FormatException {
      return const Left(FailedToParseResponse());
    }

    if (body is List) {
      if (body.isEmpty) {
        return Left(InvalidCityName(city.name));
      }
      return Right(GeographicCoordinatesModel.fromRemoteJson(body));
    } else {
      return const Left(FailedToParseResponse());
    }
  }
}

final geocodingRemoteDataSourceProvider =
    Provider((ref) => GeocodingRemoteDataSource(ref.watch(apiKeyRepoProvider)));
