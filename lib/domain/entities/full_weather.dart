import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/domain/entities/unit_system.dart';
import 'package:weather_app/domain/entities/weather.dart';

import 'city.dart';
import 'daily_forecast.dart';
import 'hourly_forecast.dart';

class FullWeather extends Equatable {
  const FullWeather({
    required this.city,
    required this.timeZoneOffset,
    required this.currentWeather,
    required this.dailyForecasts,
    required this.hourlyForecasts,
    required this.unitSystem,
  });

  final City city;

  final Duration timeZoneOffset;

  final Weather currentWeather;

  final List<DailyForecast> dailyForecasts;

  final List<HourlyForecast> hourlyForecasts;

  final UnitSystem unitSystem;

  DailyForecast get currentDayForecast => minBy(
        dailyForecasts.where(
          (forecast) =>
              forecast.date.add(timeZoneOffset).weekday ==
              currentWeather.date.add(timeZoneOffset).weekday,
        ),
        (forecast) => forecast.date.difference(currentWeather.date).abs(),
      )!;

  @override
  List<Object> get props => [
        city,
        timeZoneOffset,
        currentWeather,
        dailyForecasts,
        hourlyForecasts,
        unitSystem
      ];

  FullWeather changeUnitSystem(UnitSystem newUnitSystem) {
    if (unitSystem == newUnitSystem) {
      return this;
    }

    return FullWeather(
      unitSystem: newUnitSystem,
      city: city,
      timeZoneOffset: timeZoneOffset,
      currentWeather: currentWeather.changeUnitSystem(newUnitSystem),
      hourlyForecasts: [
        for (final forecast in hourlyForecasts)
          forecast.changeUnitSystem(newUnitSystem)
      ],
      dailyForecasts: [
        for (final forecast in dailyForecasts)
          forecast.changeUnitSystem(newUnitSystem)
      ],
    );
  }
}
