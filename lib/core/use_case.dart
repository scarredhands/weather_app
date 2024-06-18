import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/core/failure.dart';

import 'either.dart';

abstract class UseCase<R, P> {
  Future<Either<Failure, R>> call(P params);
}

@sealed
class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object> get props => const [];
}
