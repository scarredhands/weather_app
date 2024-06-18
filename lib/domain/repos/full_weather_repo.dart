import 'package:riverpod/riverpod.dart';

import '../../core/either.dart';
import '../../core/failure.dart';
import '../entities/city.dart';
import '../entities/full_weather.dart';

abstract class FullWeatherRepo {
  Future<Either<Failure, FullWeather>> getFullWeather(City city);
}

final fullWeatherRepoProvider =
    Provider<FullWeatherRepo>((ref) => throw UnimplementedError());
