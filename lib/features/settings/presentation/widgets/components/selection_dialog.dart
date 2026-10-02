import 'package:flutter/material.dart';

/// Reusable modal selection dialog presenting a list of typed choices with radio tiles.
class SelectionDialog<T> extends StatelessWidget {
  /// Dialog title heading.
  final String title;

  /// Currently selected item value.
  final T currentValue;

  /// Selectable options list.
  final List<T> items;

  /// Function resolving human-readable label for an [item].
  final String Function(T item) itemLabel;

  /// Optional function resolving subtitle description for an [item].
  final String Function(T item)? itemSubtitle;

  /// Callback invoked when an item is selected.
  final ValueChanged<T> onSelected;

  /// Creates a [SelectionDialog].
  const SelectionDialog({
    super.key,
    required this.title,
    required this.currentValue,
    required this.items,
    required this.itemLabel,
    this.itemSubtitle,
    required this.onSelected,
  });

  /// Displays the selection dialog and invokes [onSelected] on choice.
  static Future<void> show<T>(
    BuildContext context, {
    required String title,
    required T currentValue,
    required List<T> items,
    required String Function(T item) itemLabel,
    String Function(T item)? itemSubtitle,
    required ValueChanged<T> onSelected,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => SelectionDialog<T>(
        title: title,
        currentValue: currentValue,
        items: items,
        itemLabel: itemLabel,
        itemSubtitle: itemSubtitle,
        onSelected: (value) {
          onSelected(value);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: [
        RadioGroup<T>(
          groupValue: currentValue,
          onChanged: (selected) {
            if (selected != null) {
              onSelected(selected);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final item in items)
                RadioListTile<T>(
                  value: item,
                  title: Text(itemLabel(item)),
                  subtitle: itemSubtitle != null
                      ? Text(itemSubtitle!(item))
                      : null,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
