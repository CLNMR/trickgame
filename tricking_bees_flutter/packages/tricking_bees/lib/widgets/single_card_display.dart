import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tb_core/tb_core.dart';

import 'own_text.dart';

/// Widget to display a card.
class SingleCardDisplay extends StatelessWidget {
  /// Create a new [SingleCardDisplay].
  const SingleCardDisplay({
    super.key,
    required this.cardColor,
    required this.symbol,
    this.onTap,
    this.isDisabled = false,
  });

  /// A card unknown to the user.
  factory SingleCardDisplay.unknown({
    void Function()? onTap,
    bool isDisabled = false,
  }) =>
      SingleCardDisplay(
        cardColor: Colors.blueGrey,
        symbol: '?',
        onTap: onTap,
        isDisabled: isDisabled,
      );

  /// A card display from a given [cardKey].
  factory SingleCardDisplay.fromCardKey({
    required GameCard cardKey,
    void Function()? onTap,
    bool isDisabled = false,
    bool isHidden = false,
  }) =>
      isHidden
          ? SingleCardDisplay.unknown(
              onTap: onTap,
              isDisabled: isDisabled,
            )
          : SingleCardDisplay(
              cardColor: Color(cardKey.color.hexValue),
              symbol: cardKey.displayName,
              onTap: onTap,
              isDisabled: isDisabled,
            );

  /// The card color to display.
  final Color cardColor;

  /// The symbol to display.
  final String symbol;

  /// Whether the view of the card is disabled (untappable)
  final bool isDisabled;

  /// The function to call when the card is tapped.
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: SizedBox(
          height: 100,
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(1),
                    color: cardColor,
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
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
              ],
            ),
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
          text: symbol,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<void Function()?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('isDisabled', isDisabled))
      ..add(StringProperty('symbol', symbol))
      ..add(ColorProperty('cardColor', cardColor));
  }
}
