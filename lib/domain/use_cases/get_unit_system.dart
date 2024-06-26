import 'package:riverpod/riverpod.dart';

import '../../core/either.dart';
import '../../core/failure.dart';
import '../../core/use_case.dart';
import '../entities/unit_system.dart';
import '../repos/unit_system_repo.dart';

class GetUnitSystem implements UseCase<UnitSystem, NoParams> {
  const GetUnitSystem(this.repo);

  final UnitSystemRepo repo;

  @override
  Future<Either<Failure, UnitSystem>> call(NoParams params) =>
      repo.getUnitSystem();
}

final getUnitSystemProvider =
    Provider((ref) => GetUnitSystem(ref.watch(unitSystemRepoProvider)));
