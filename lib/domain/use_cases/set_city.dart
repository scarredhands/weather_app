import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

import '../../core/either.dart';
import '../../core/failure.dart';
import '../../core/use_case.dart';
import '../entities/city.dart';
import '../repos/city_repo.dart';

class SetCity implements UseCase<void, SetCityParams> {
  const SetCity(this.repo);

  final CityRepo repo;

  @override
  Future<Either<Failure, void>> call(SetCityParams params) =>
      repo.setCity(params.city);
}

class SetCityParams extends Equatable {
  const SetCityParams(this.city);

  final City city;

  @override
  List<Object?> get props => [city];
}

final setCityProvider = Provider((ref) => SetCity(ref.watch(cityRepoProvider)));
