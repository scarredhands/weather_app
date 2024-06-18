import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';
import 'package:weather_app/core/either.dart';

import '../../core/failure.dart';
import '../../core/use_case.dart';
import '../entities/unit_system.dart';
import '../repos/unit_system_repo.dart';

class SetUnitSystem implements UseCase<void, SetUnitSystemParams> {
  const SetUnitSystem(this.repo);

  final UnitSystemRepo repo;

  @override
  Future<Either<Failure, void>> call(SetUnitSystemParams params) =>
      repo.setUnitSystem(params.unitSystem);
}

class SetUnitSystemParams extends Equatable {
  const SetUnitSystemParams(this.unitSystem);

  final UnitSystem unitSystem;

  @override
  List<Object?> get props => [unitSystem];
}

final setUnitSystemProvider =
    Provider((ref) => SetUnitSystem(ref.watch(unitSystemRepoProvider)));
