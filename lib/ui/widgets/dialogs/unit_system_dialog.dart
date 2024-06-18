import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/unit_system.dart';
import '../../state_notifiers/unit_system_state_notifier.dart';

class UnitSystemDialog extends ConsumerWidget {
  static const _dialogOptions = {
    'Metric': UnitSystem.metric,
    'Imperial': UnitSystem.imperial,
  };

  const UnitSystemDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitSystemState = ref.watch(unitSystemStateNotifierProvider);
    final unitSystemStateNotifier =
        ref.watch(unitSystemStateNotifierProvider.notifier);

    final radios = [
      for (final entry in _dialogOptions.entries)
        RadioListTile<UnitSystem>(
          title: Text(
            entry.key,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
          ),
          value: entry.value,
          groupValue: unitSystemState.unitSystem,
          onChanged: (newValue) {
            unitSystemStateNotifier.setUnitSystem(newValue!);
            Navigator.pop(context);
          },
        )
    ];

    return SimpleDialog(
      title: Text(
        'Unit system',
        style: TextStyle(
          color: Theme.of(context).textTheme.titleMedium!.color,
        ),
      ),
      children: [Column(mainAxisSize: MainAxisSize.min, children: radios)],
    );
  }
}
