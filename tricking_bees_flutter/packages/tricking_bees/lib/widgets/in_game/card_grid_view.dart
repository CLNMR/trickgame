import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tb_core/tb_core.dart';

import '../single_card_display.dart';

/// CardGridView is a widget that displays a list of cards in a horizontal grid.
class CardGridView extends StatelessWidget {
  /// Creates a [CardGridView].
  const CardGridView({
    super.key,
    required this.cards,
    this.onTap,
    this.isDisabled = false,
    this.rowNumber = 1,
  }) : super();

  /// The cards to be displayed
  final CardStack cards;

  /// Whether the gridView is disabled (untappable)
  final bool isDisabled;

  /// The function that should be called on tap of a card.
  final void Function(GameCard)? onTap;

  /// The number of rows for the cards to be displayed.
  final int rowNumber;

  @override
  Widget build(BuildContext context) => GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: rowNumber,
          childAspectRatio: 1.1,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return SingleCardDisplay(
            cardKey: card,
            isDisabled: isDisabled,
            onTap: () => onTap?.call(card),
          );
        },
      );

  // @override
  // Widget build(BuildContext context) => SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Row(
  //         children: cards
  //             .map(
  //               (card) => SingleCardDisplay(
  //                 cardKey: card,
  //                 onTap: () => onTap!(card),
  //               ),
  //             )
  //             .toList(),
  //       ),
  //     );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<GameCard>('cards', cards))
      ..add(
        ObjectFlagProperty<void Function(GameCard p1)?>.has('onTap', onTap),
      )
      ..add(IntProperty('rowNumber', rowNumber))
      ..add(DiagnosticsProperty<bool>('isDisabled', isDisabled));
  }

  // SizedBox(
  //       height: 170,
  //       width: 400,
  //       child: GridView.builder(
  //         scrollDirection: Axis.horizontal,
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 1,
  //           mainAxisSpacing: 4,
  //           crossAxisSpacing: 4,
  //         ),
  //         itemCount: cards.length,
  //         itemBuilder: (context, index) => SizedBox(
  //           width: 100,
  //           child: SingleCardDisplay(
  //             cardKey: cards[index],
  //             onTap: () => onTap!(cards[index]),
  //           ),
  //         ),
  //       ),
  //     );
}
