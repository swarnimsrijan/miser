import 'package:material_ui/material_ui.dart';

/// Obscured password prompt for encrypted statements. The value only lives in
/// this dialog's controller and the upload call; it is never logged or stored.
Future<String?> showStatementPasswordDialog(
  BuildContext context, {
  required bool incorrect,
  String? filename,
}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _PasswordDialog(incorrect: incorrect, filename: filename),
  );
}

class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog({required this.incorrect, this.filename});

  final bool incorrect;
  final String? filename;

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final _controller = TextEditingController();
  bool _obscured = true;

  @override
  void dispose() {
    _controller.clear();
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.isEmpty) return;
    Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(widget.incorrect ? 'Incorrect password' : 'Password required'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.incorrect
                  ? 'That password did not unlock ${widget.filename ?? 'the statement'}. Try again.'
                  : '${widget.filename ?? 'This statement'} is password protected. '
                      'Banks often use your date of birth or part of your account number.',
              style: widget.incorrect ? TextStyle(color: scheme.error) : null,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('statement-password-field'),
              controller: _controller,
              autofocus: true,
              obscureText: _obscured,
              enableSuggestions: false,
              autocorrect: false,
              autofillHints: const <String>[],
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'Statement password',
                suffixIcon: IconButton(
                  tooltip: _obscured ? 'Show' : 'Hide',
                  icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscured = !_obscured),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(
          key: const Key('statement-password-submit'),
          onPressed: _submit,
          child: const Text('Unlock'),
        ),
      ],
    );
  }
}
