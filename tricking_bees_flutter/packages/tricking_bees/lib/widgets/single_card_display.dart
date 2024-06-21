import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tb_core/tb_core.dart';

import 'own_text.dart';

/// Widget to display a card.
class SingleCardDisplay extends StatelessWidget {
  /// Create a new [SingleCardDisplay].
  const SingleCardDisplay({
    super.key,
    required this.cardKey,
    this.onTap,
    this.isDisabled = false,
    this.isHidden = false,
  });

  /// The card key to display.
  final GameCard cardKey;

  /// Whether the view of the card is disabled (untappable)
  final bool isDisabled;

  /// Whether the card is hidden.
  final bool isHidden;

  /// The function to call when the card is tapped.
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: isHidden ? '' : cardKey.name,
        child: GestureDetector(
          onTap: isDisabled ? null : onTap,
          child: Stack(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(1),
                  color: isHidden
                      ? Colors.blueGrey
                      : Color(
                          cardKey.color.hexValue,
                        ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 3,
                    right: 3,
                    bottom: 3,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: _buildNumberDisplay(size: 30),
                  ),
                ),
              ),
              ..._getOverlayNumberWidgets(),
              if (isDisabled)
                Positioned.fill(
                  top: 50,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      Icons.close,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  List<Widget> _getOverlayNumberWidgets() => [
        Alignment.topLeft,
        Alignment.topRight,
        Alignment.bottomRight,
        Alignment.bottomLeft,
      ]
          .map(
            (alignment) => Align(
              alignment: alignment,
              child: _buildNumberDisplay(size: 12),
            ),
          )
          .toList();
  Widget _buildNumberDisplay({double size = 15}) => Padding(
        padding: const EdgeInsets.all(3),
        child: OwnText(
          translate: false,
          text: isHidden ? '?' : cardKey.displayName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GameCard>('cardKey', cardKey))
      ..add(ObjectFlagProperty<void Function()?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('isDisabled', isDisabled))
      ..add(DiagnosticsProperty<bool>('isCrossedOut', isHidden));
  }
}
