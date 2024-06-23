import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tb_core/tb_core.dart';

/// Adds utility to display enriched text.
extension UiRichTrObject on RichTrObject {
  /// Returns a [InlineSpan] that represents the rich translation object.
  InlineSpan getEnrichedSpan(BuildContext context, List<String> playerNames) {
    switch (trType) {
      case RichTrType.player:
        final index = value as int;
        return _getPlayerSpan(playerNames[index], index);
      case RichTrType.number:
        return TextSpan(
          text: value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      case RichTrType.numberWithOperator:
        final val = value as int;
        return TextSpan(
          text: val > 0 ? '+ $val' : '- ${val.abs()}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      case RichTrType.card:
        final card = value as GameCard;
        return TextSpan(
          text: tr(card.name),
          style: TextStyle(
            color: Color(card.color.hexValue),
            fontWeight: FontWeight.bold,
          ),
        );
      case RichTrType.cardList:
        final cards = value as CardStack;
        return TextSpan(
          children: cards
              .map(
                (card) => RichTrObject(RichTrType.card, value: card)
                    .getEnrichedSpan(context, playerNames),
              )
              .expand((span) => [span, const TextSpan(text: ', ')])
              .toList()
            ..removeLast(),
        );
      case RichTrType.playerList:
        return _getSpanForList(value, RichTrType.player, context, playerNames);
      case RichTrType.role:
        return _getRoleSpan(value as RoleCatalog);
      default:
        return TextSpan(
          text: value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
    }
  }

  /// Retrieve the TextSpan for a list of values of the same type.
  TextSpan _getSpanForList(
    List<dynamic> values,
    RichTrType singularType,
    BuildContext context,
    List<String> playerNames,
  ) =>
      TextSpan(
        children: values
            .map(
              (val) => RichTrObject(singularType, value: val)
                  .getEnrichedSpan(context, playerNames),
            )
            .expand((span) => [span, const TextSpan(text: ', ')])
            .toList()
          ..removeLast(),
      );

  InlineSpan _getPlayerSpan(String playerName, int factionIndex) => TextSpan(
        text: playerName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );

  InlineSpan _getRoleSpan(RoleCatalog event) {
    final roleSpan = TextSpan(
      text: tr(event.locName),
      style: TextStyle(
        color: Colors.teal[600],
        fontWeight: FontWeight.bold,
      ),
    );
    const icon = WidgetSpan(
      child: Icon(Icons.warning_amber, size: 8),
      alignment: PlaceholderAlignment.middle,
    );
    return _getSpanWithTooltip(
      TextSpan(
        children: [
          icon,
          roleSpan,
        ],
      ),
      tr(event.descBenefits),
    );
  }

  WidgetSpan _getSpanWithTooltip(InlineSpan child, String tooltip) =>
      WidgetSpan(
        child: MouseRegion(
          child: Tooltip(
            message: tooltip,
            child: RichText(
              text: child,
            ),
          ),
        ),
      );
}
