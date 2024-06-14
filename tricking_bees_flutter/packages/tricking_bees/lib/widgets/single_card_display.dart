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
    required this.onTap,
    this.isDisabled = false,
    this.isCrossedOut = false,
  });

  /// The card key to display.
  final GameCard cardKey;

  /// Whether the view of the card is disabled (untappable)
  final bool isDisabled;

  /// Whether the card is crossed out.
  final bool isCrossedOut;

  /// The function to call when the card is tapped.
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: cardKey.number.toString(),
        child: GestureDetector(
          onTap: isDisabled ? null : onTap,
          child: Stack(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(1),
                  color:
                      isDisabled ? Colors.grey[500] : const Color(0xFFcbd75b),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      Expanded(
                        child: OwnText(
                          text: cardKey.number.toString(),
                          ellipsis: true,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          _buildCardStrengthIndicator(
                            cardKey.number,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isCrossedOut)
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(
                      Icons.close,
                      color: Colors.red[900],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildCardStrengthIndicator(int strength) => SizedBox(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            children: List.generate(strength, (index) => _starIcon()),
          ),
        ),
      );

  Widget _starIcon({bool isElite = false}) => Icon(
        Icons.star,
        size: 15,
        color: isElite ? Colors.amberAccent : Colors.white,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GameCard>('cardKey', cardKey))
      ..add(ObjectFlagProperty<void Function()?>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('isDisabled', isDisabled))
      ..add(DiagnosticsProperty<bool>('isCrossedOut', isCrossedOut));
  }
}
