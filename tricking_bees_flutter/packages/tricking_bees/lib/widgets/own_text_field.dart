import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A text field.
class OwnTextField extends StatelessWidget {
  /// Creates a [OwnTextField].
  OwnTextField({
    super.key,
    this.placeholder,
    TextEditingController? controller,
    this.onChanged,
    String? initialText,
    this.label = '',
    this.obscureText = false,
    this.autocorrect = true,
    this.keyboardType,
  }) : controller = controller ?? TextEditingController(text: initialText);

  /// The placeholder text.
  final String? placeholder;

  /// The controller for the text field.
  final TextEditingController controller;

  /// The callback when the text is changed.
  final Function(String text)? onChanged;

  /// The label of the text field.
  final String label;

  /// Whether the text should be obscured.
  final bool obscureText;

  /// Whether the text should be autocorrected.
  final bool autocorrect;

  /// The type of keyboard to use.
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => TextField(
        decoration: InputDecoration(
          label: Text(label),
        ),
        style: const TextStyle(color: Colors.black),
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        autocorrect: autocorrect,
        keyboardType: keyboardType,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('placeholder', placeholder))
      ..add(
        DiagnosticsProperty<TextEditingController?>('controller', controller),
      )
      ..add(
        ObjectFlagProperty<Function(String text)?>.has('onChanged', onChanged),
      )
      ..add(StringProperty('label', label))
      ..add(DiagnosticsProperty<bool>('obscureText', obscureText))
      ..add(DiagnosticsProperty<bool>('autocorrect', autocorrect))
      ..add(DiagnosticsProperty<TextInputType?>('keyboardType', keyboardType));
  }
}
