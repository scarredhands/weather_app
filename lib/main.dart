import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:weather_app/ui/build_flavor.dart';
import 'package:weather_app/ui/screens/weather_screen.dart';
import 'package:weather_app/ui/state_notifiers/theme_state_notifier.dart' as t;
import 'package:weather_app/ui/state_notifiers/theme_state_notifier.dart';
import 'package:weather_app/ui/themes/black_theme.dart';
import 'package:weather_app/ui/themes/clima_theme.dart';
import 'package:weather_app/ui/themes/dark_theme.dart';
import 'package:weather_app/ui/themes/light_theme.dart';

import 'data/models/dark_theme_model.dart';
import 'data/models/theme_model.dart';
import 'data/provider.dart';
import 'data/repos/city_repo_impl.dart';
import 'data/repos/full_weather_repo.dart';
import 'data/repos/unit_system_repo_impl.dart';
import 'domain/repos/city_repo.dart';
import 'domain/repos/full_weather_repo.dart';
import 'domain/repos/unit_system_repo.dart';

Future<void> main({
  TransitionBuilder? builder,
  Widget Function(Widget widget)? topLevelBuilder,
  Locale? Function(BuildContext)? getLocale,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final widget = ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      cityRepoProvider.overrideWithProvider(
        Provider((ref) => ref.watch(cityRepoImplProvider)),
      ),
      unitSystemRepoProvider.overrideWithProvider(
        Provider((ref) => ref.watch(unitSystemRepoImplProvider)),
      ),
      fullWeatherRepoProvider.overrideWithProvider(
        Provider((ref) => ref.watch(fullWeatherRepoImplProvider)),
      ),
    ],
    child: _App(builder: builder, getLocale: getLocale),
  );

  runApp(topLevelBuilder?.call(widget) ?? widget);
}

class _App extends HookConsumerWidget {
  const _App({this.builder, this.getLocale});

  final TransitionBuilder? builder;
  final Locale? Function(BuildContext)? getLocale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    validateBuildFlavor();

    // Watch the notifier without triggering updates in `useEffect`
    final themeStateNotifier = ref.read(themeStateNotifierProvider.notifier);

    // Use `useEffect` to load the theme, making sure it does not directly modify state during the build phase.
    useEffect(() {
      // Loading theme with a delay to ensure it's after build completion.
      Future.microtask(() {
        themeStateNotifier.loadTheme();
      });
      return null; // No cleanup needed.
    }, [themeStateNotifier]);

    // Now watch the themeState provider.
    final themeState = ref.watch(themeStateNotifierProvider);

    // Ensure the app is not built until the theme is fully loaded.
    if (themeState is t.EmptyState || themeState is t.Loading) {
      return const SizedBox.shrink();
    }

    return Sizer(
      builder: (context, orientation, screenType) => MaterialApp(
        locale: getLocale?.call(context),
        builder: (context, child) {
          // Determine theme based on current brightness
          final ClimaThemeData climateTheme;

          switch (Theme.of(context).brightness) {
            case Brightness.light:
              climateTheme = lightClimaTheme;
              break;
            case Brightness.dark:
              climateTheme = {
                DarkThemeModel.black: blackClimaTheme,
                DarkThemeModel.darkGrey: darkGreyClimaTheme,
              }[themeState.darkTheme]!;
          }

          child = ClimaTheme(data: climateTheme, child: child!);

          return builder?.call(context, child) ?? child;
        },
        home: const WeatherScreen(),
        theme: lightTheme,
        darkTheme: {
          DarkThemeModel.black: blackTheme,
          DarkThemeModel.darkGrey: darkGreyTheme,
        }[themeState.darkTheme],
        themeMode: const {
          ThemeModel.systemDefault: ThemeMode.system,
          ThemeModel.light: ThemeMode.light,
          ThemeModel.dark: ThemeMode.dark,
        }[themeState.theme],
      ),
    );
  }
}
