import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../data/models/api_key_model.dart';
import '../../../state_notifiers/api_key_state_notifier.dart';
import '../../../utilities/snack_bars.dart';

class ApiKeyResetDialog extends ConsumerWidget {
  const ApiKeyResetDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AlertDialog(
        title: Text(
          'Reset API Key?',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleMedium!.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(apiKeyStateNotifierProvider.notifier)
                  .setApiKey(const ApiKeyModel.default_());
              showSnackBar(context, text: 'API key reset successfully.');
              Navigator.pop(context);
            },
            child: Text(
              'RESET',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      );
}
