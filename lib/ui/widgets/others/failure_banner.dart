import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../core/failure.dart';
import '../../utilities/constants.dart';

class FailureBanner extends HookWidget {
  const FailureBanner({
    required this.onRetry,
    required this.failure,
    super.key,
  });

  final void Function() onRetry;

  final Failure failure;

  @override
  Widget build(BuildContext context) => MaterialBanner(
        forceActionsBelow: true,
        content: Text(
          () {
            if (failure is NoConnection) {
              return 'Looks like you have no internet connection. Please make sure you are connected then try again.';
            } else if (failure is FailedToParseResponse) {
              return "Looks like we're having trouble parsing the response. Please try again later.";
            } else if (failure is ServerDown) {
              return 'Looks like the server is down. Please try again later.';
            } else if (failure is InvalidCityName) {
              return 'Looks like an invalid city name. Please check it and try again.';
            } else if (failure is InvalidApiKey) {
              return "Looks like the API key being used isn't valid, probably because it expired. Please fix the issue and try again.";
            } else if (failure is CallLimitExceeded) {
              return "Looks like you reached the API key's call limit. Please try again later.";
            } else {
              throw ArgumentError('Did not expect $failure');
            }
          }(),
          style: TextStyle(
            fontSize:
                MediaQuery.of(context).size.shortestSide < kTabletBreakpoint
                    ? 13.sp
                    : 7.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: onRetry,
            child: Text(
              'RETRY',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      );
}
