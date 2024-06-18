import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/models/dark_theme_model.dart';
import '../../state_notifiers/theme_state_notifier.dart';

class DarkThemeDialog extends ConsumerWidget {
  static const _dialogOptions = {
    'Default': DarkThemeModel.darkGrey,
    'Black': DarkThemeModel.black,
  };

  const DarkThemeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStateNotifier = ref.watch(themeStateNotifierProvider.notifier);
    final darkTheme = ref.watch(
      themeStateNotifierProvider.select((state) => state.darkTheme),
    );

    final radios = [
      for (final entry in _dialogOptions.entries)
        RadioListTile<DarkThemeModel>(
          title: Text(
            entry.key,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
          ),
          value: entry.value,
          groupValue: darkTheme,
          onChanged: (newValue) {
            themeStateNotifier.setDarkTheme(newValue!);
            Navigator.pop(context);
          },
        )
    ];

    return SimpleDialog(
      title: Text(
        'Dark theme',
        style: TextStyle(
          color: Theme.of(context).textTheme.titleMedium!.color,
        ),
      ),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: radios,
        ),
      ],
    );
  }
}
