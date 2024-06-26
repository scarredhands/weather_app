import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

import '../../core/either.dart';
import '../../core/failure.dart';
import '../../core/use_case.dart';
import '../entities/city.dart';
import '../entities/full_weather.dart';
import '../repos/full_weather_repo.dart';

class GetFullWeather implements UseCase<FullWeather, GetFullWeatherParams> {
  const GetFullWeather(this.repo);

  final FullWeatherRepo repo;

  @override
  Future<Either<Failure, FullWeather>> call(GetFullWeatherParams params) =>
      repo.getFullWeather(params.city);
}

class GetFullWeatherParams extends Equatable {
  const GetFullWeatherParams({required this.city});

  final City city;

  @override
  List<Object?> get props => [city];
}

final getFullWeatherProvider =
    Provider((ref) => GetFullWeather(ref.watch(fullWeatherRepoProvider)));
