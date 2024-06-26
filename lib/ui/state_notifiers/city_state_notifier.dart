import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';

import '../../core/failure.dart';
import '../../core/use_case.dart';
import '../../domain/entities/city.dart';
import '../../domain/use_cases/get_city.dart';
import '../../domain/use_cases/set_city.dart';

@sealed
@immutable
abstract class CityState extends Equatable {
  const CityState();
}

class Empty extends CityState {
  const Empty();

  @override
  List<Object?> get props => const [];
}

class Loading extends CityState {
  const Loading();

  @override
  List<Object?> get props => const [];
}

class Loaded extends CityState {
  const Loaded(this.city);

  final City city;

  @override
  List<Object?> get props => [city];
}

class Error extends CityState {
  const Error(this.failure, {this.city});

  final Failure failure;

  final City? city;

  @override
  List<Object?> get props => [failure, city];
}

class CityStateNotifier extends StateNotifier<CityState> {
  CityStateNotifier(this.getCity, this.setCityUseCase) : super(const Empty());

  final GetCity getCity;

  final SetCity setCityUseCase;

  City? get _currentCity {
    final state = this.state;
    if (state is Loaded) {
      return state.city;
    } else if (state is Error) {
      return state.city;
    } else {
      return null;
    }
  }

  Future<void> loadCity() async {
    state = const Loading();
    final data = await getCity(const NoParams());
    state = data.fold(Error.new, Loaded.new);
  }

  Future<void> setCity(City city) async {
    (await setCityUseCase(SetCityParams(city))).fold((failure) {
      state = Error(failure, city: _currentCity);
    }, (_) {
      state = Loaded(city);
    });
  }
}

final cityStateNotifierProvider =
    StateNotifierProvider<CityStateNotifier, CityState>(
  (ref) =>
      CityStateNotifier(ref.watch(getCityProvider), ref.watch(setCityProvider)),
);
