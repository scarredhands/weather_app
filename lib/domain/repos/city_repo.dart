import 'package:riverpod/riverpod.dart';

import '../../core/either.dart';
import '../../core/failure.dart';
import '../entities/city.dart';

abstract class CityRepo {
  Future<Either<Failure, City>> getCity();

  Future<Either<Failure, void>> setCity(City city);
}

final cityRepoProvider =
    Provider<CityRepo>((ref) => throw UnimplementedError());
