import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/either.dart';
import '../../core/failure.dart';
import '../models/dark_theme_model.dart';
import '../models/theme_model.dart';
import '../provider.dart';

const String _themeKey = 'app_theme';

const String _darkThemeKey = 'app_dark_theme';

class ThemeLocalDataSource {
  ThemeLocalDataSource(this._prefs);
  final SharedPreferences _prefs;

  Future<Either<Failure, ThemeModel?>> getTheme() async {
    final string = _prefs.getString(_themeKey);

    if (string == null) {
      return const Right(null);
    }

    return Right(ThemeModel.parse(string));
  }

  Future<Either<Failure, void>> setTheme(ThemeModel theme) async {
    await _prefs.setString(_themeKey, theme.toString());

    return const Right(null);
  }

  Future<Either<Failure, DarkThemeModel?>> getDarkTheme() async {
    final string = _prefs.getString(_darkThemeKey);
    if (string == null) {
      return const Right(null);
    }
    return Right(DarkThemeModel.parse(string));
  }

  Future<Either<Failure, void>> setDarkTheme(DarkThemeModel theme) async {
    await _prefs.setString(_darkThemeKey, theme.toString());

    return const Right(null);
  }
}

final themeLocalDataSourceProvider = Provider(
  (ref) => ThemeLocalDataSource(ref.watch(sharedPreferencesProvider)),
);
