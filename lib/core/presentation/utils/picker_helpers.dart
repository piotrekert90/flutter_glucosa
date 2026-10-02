import 'package:flutter/material.dart';

/// Crash-safe wrappers around Material date and time pickers.
///
/// In landscape orientation the default Material time picker can overflow
/// when the keyboard entry mode is active, and date pickers can exceed the
/// available height. These helpers force the compact dial layout in
/// landscape and wrap dialogs in scrollable containers, eliminating the
/// overflow crashes on small and rotated devices.
abstract final class PickerHelpers {
  /// Shows a date picker protected against landscape overflow.
  ///
  /// Returns the selected date, or null when the dialog is dismissed.
  static Future<DateTime?> showSafeDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        final dialog = child ?? const SizedBox.shrink();
        if (MediaQuery.orientationOf(context) != Orientation.landscape) {
          return dialog;
        }
        return Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.95,
              ),
              child: dialog,
            ),
          ),
        );
      },
    );
  }

  /// Shows a time picker protected against landscape overflow.
  ///
  /// Forces [TimePickerEntryMode.dialOnly] in landscape, where the keyboard
  /// input mode overflows on compact heights. Returns the selected time,
  /// or null when the dialog is dismissed.
  static Future<TimeOfDay?> showSafeTimePicker({
    required BuildContext context,
    required TimeOfDay initialTime,
  }) {
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: isLandscape
          ? TimePickerEntryMode.dialOnly
          : TimePickerEntryMode.dial,
      builder: (context, child) {
        final dialog = child ?? const SizedBox.shrink();
        if (MediaQuery.orientationOf(context) != Orientation.landscape) {
          return dialog;
        }
        return Center(child: SingleChildScrollView(child: dialog));
      },
    );
  }
}
