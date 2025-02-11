import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:json_annotation/json_annotation.dart';

import 'tb_log_entry_type.dart';

part 'cards_dealt.g.dart';

@JsonSerializable()

/// Log a player playing a card (without specifying the effects).
class LogCardsDealt extends LogEntry {
  /// Creates a [LogCardsDealt].
  LogCardsDealt({
    required this.cardAmount,
    required this.playerIndex,
    int? indentLevel,
  }) : super(
          entryType: TBLogEntryType.cardsDealt,
          indentLevel: indentLevel ?? 2,
        );

  /// Creates a [LogCardsDealt] from a JSON map.
  factory LogCardsDealt.fromJson(Map<String, dynamic> json) =>
      _$LogCardsDealtFromJson(json);

  /// The amount of additional cards dealt.
  final int cardAmount;

  /// The playerIndex of the player who played the card.
  final PlayerIndex playerIndex;

  @override
  Map<String, dynamic> toJson() => _$LogCardsDealtToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) =>
      TrObject(localizedKey, richTrObjects: _getRichTrObjects());

  List<RichTrObject> _getRichTrObjects() => [
        RichTrObject(
          RichTrType.player,
          value: playerIndex,
        ),
        RichTrObject(RichTrType.number, value: cardAmount),
      ];
}
