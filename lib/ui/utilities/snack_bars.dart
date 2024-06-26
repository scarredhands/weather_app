import 'package:flutter/material.dart';

import '../../core/failure.dart';

void showFailureSnackBar(
  BuildContext context, {
  required Failure failure,
  VoidCallback? onRetry,
  int? duration,
}) {
  final text = () {
    if (failure is NoConnection) {
      return 'No network connection';
    } else if (failure is FailedToParseResponse) {
      return 'Could not parse response';
    } else if (failure is ServerDown) {
      return "Can't connect to server";
    } else if (failure is InvalidCityName) {
      return 'Invalid city name';
    } else if (failure is CallLimitExceeded) {
      return 'API key call limit reached';
    } else {
      throw ArgumentError('Did not expect $failure');
    }
  }();

  showSnackBar(
    context,
    text: text,
    actionText: 'Retry',
    onPressed: onRetry,
    duration: duration,
  );
}

void showSnackBar(
  BuildContext context, {
  required String text,
  String? actionText,
  VoidCallback? onPressed,
  int? duration,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.removeCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      content: Text(text),
      duration: Duration(seconds: duration ?? 4),
      action: onPressed != null
          ? SnackBarAction(
              label: actionText!,
              textColor: Theme.of(context).colorScheme.secondary,
              onPressed: onPressed,
            )
          : null,
    ),
  );
}
