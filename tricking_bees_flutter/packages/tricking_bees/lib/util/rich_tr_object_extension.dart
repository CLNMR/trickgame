import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tb_core/tb_core.dart';

/// Adds utility to display enriched text.
extension UiRichTrObject on RichTrObject {
  /// Returns a [InlineSpan] that represents the rich translation object.
  InlineSpan getEnrichedSpan(BuildContext context, List<String> playerNames) {
    switch (trType) {
      case RichTrType.playerAndFaction:
        return _getPlayerAndFactionSpan(value as int, playerNames);
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
      case RichTrType.event:
        return _getRoleSpan(value as RoleCatalog);
      default:
        return TextSpan(
          text: value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
    }
  }

  InlineSpan _getPlayerSpan(String playerName, int factionIndex) => TextSpan(
        text: playerName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );

  InlineSpan _getPlayerAndFactionSpan(
    int playerIndex,
    List<String> playerNames,
  ) {
    const icon = WidgetSpan(
      child: Icon(Icons.person, size: 8),
      alignment: PlaceholderAlignment.middle,
    );
    return TextSpan(
      children: [
        icon,
        _getPlayerSpan(playerNames[playerIndex], playerIndex),
      ],
    );
  }

  InlineSpan _getRoleSpan(RoleCatalog event) {
    final eventSpan = TextSpan(
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
          eventSpan,
        ],
      ),
      tr(event.description),
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
