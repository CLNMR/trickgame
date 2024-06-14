import 'package:json_annotation/json_annotation.dart';

import '../../../cards/game_card.dart';
import '../../../wrapper/rich_tr_object.dart';
import '../../../wrapper/rich_tr_object_type.dart';
import '../../../wrapper/tr_object.dart';
import '../game.dart';
import 'log_entry.dart';
import 'log_entry_type.dart';

part 'card_played.g.dart';

@JsonSerializable()

/// Log a player playing a card (without specifying the effects).
class LogCardPlayed extends LogEntry {
  /// Creates a [LogCardPlayed].
  LogCardPlayed({
    required this.cardKey,
    required this.playerIndex,
    int? indentLevel,
  }) : super(
          entryType: LogEntryType.cardPlayed,
          indentLevel: indentLevel ?? 2,
        );

  /// Creates a [LogCardPlayed] from a JSON map.
  factory LogCardPlayed.fromJson(Map<String, dynamic> json) =>
      _$LogCardPlayedFromJson(json);

  /// The key for the card that has been played.
  final GameCard cardKey;

  /// The playerIndex of the player who played the card.
  final int playerIndex;

  @override
  Map<String, dynamic> toJson() => _$LogCardPlayedToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) => TrObject(
        localizedKey,
        richTrObjects: [
          RichTrObject(
            RichTrType.player,
            value: playerIndex,
          ),
          RichTrObject(RichTrType.card, value: cardKey),
        ],
      );
}
