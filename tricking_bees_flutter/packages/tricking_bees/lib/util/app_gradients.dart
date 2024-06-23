import 'package:flutter/material.dart';

/// A class containing all the gradients used in the app.
class AppGradients {
  /// A gradient from indigo to yellow.
  static LinearGradient indigoToYellow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.indigo[600]!.withOpacity(0.5),
      Colors.yellow[50]!.withOpacity(0.5),
    ],
  );
}
