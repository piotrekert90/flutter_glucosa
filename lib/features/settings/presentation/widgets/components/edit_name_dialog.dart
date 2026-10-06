import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

/// Modal dialog for modifying the user's display name or nickname.
class EditNameDialog extends StatefulWidget {
  /// The current display name before editing.
  final String currentName;

  /// Callback invoked with the validated new name upon saving.
  final ValueChanged<String> onSaved;

  /// Creates an [EditNameDialog].
  const EditNameDialog({
    super.key,
    required this.currentName,
    required this.onSaved,
  });

  /// Displays the edit name dialog.
  static Future<void> show(
    BuildContext context, {
    required String currentName,
    required ValueChanged<String> onSaved,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) =>
          EditNameDialog(currentName: currentName, onSaved: onSaved),
    );
  }

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    final l10n = AppLocalizations.of(context)!;
    if (_controller.text.trim().isEmpty) {
      setState(() => _errorText = l10n.nameCannotBeEmpty);
      return;
    }
    widget.onSaved(_controller.text.trim());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.editName),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: l10n.name,
          hintText: l10n.nameHint,
          errorText: _errorText,
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) {
          if (_errorText != null) setState(() => _errorText = null);
        },
        onSubmitted: (_) => _handleSave(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _handleSave, child: Text(l10n.save)),
      ],
    );
  }
}
