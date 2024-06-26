import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class ClimaTheme extends InheritedWidget {
  const ClimaTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final ClimaThemeData data;

  @override
  bool updateShouldNotify(ClimaTheme old) => data != old.data;

  static ClimaThemeData of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ClimaTheme>();
    assert(result != null, 'ClimaTheme not found in context');
    return result!.data;
  }
}

class ClimaThemeData extends Equatable {
  const ClimaThemeData({
    required this.sheetPillColor,
    required this.loadingIndicatorColor,
  });

  final Color sheetPillColor;

  final Color loadingIndicatorColor;

  @override
  List<Object?> get props => [sheetPillColor, loadingIndicatorColor];
}
