import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/either.dart';
import '../../core/failure.dart';
import '../../domain/entities/city.dart';
import '../models/city_model.dart';

const _randomCityNames = ['Amsterdam', 'London', 'Paris', 'New York', 'London'];

class CityRandomDataSource {
  Future<Either<Failure, CityModel>> getCity() async => Right(CityModel(
      City(name: _randomCityNames[Random().nextInt(_randomCityNames.length)])));
}

final cityRandomDataSourceProvider = Provider((ref) => CityRandomDataSource());
