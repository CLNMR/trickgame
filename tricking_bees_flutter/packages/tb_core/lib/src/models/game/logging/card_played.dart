import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../cards/game_card.dart';
import '../../../util/tb_rich_tr_object_type.dart';
import '../tb_game.dart';
import 'tb_log_entry_type.dart';

part 'card_played.g.dart';

@JsonSerializable()

/// Log a player playing a card (without specifying the effects).
class LogCardPlayed extends LogEntry {
  /// Creates a [LogCardPlayed].
  LogCardPlayed({
    required this.cardKey,
    required this.playerIndex,
    this.isHidden = false,
    int? indentLevel,
  }) : super(
          entryType: TBLogEntryType.cardPlayed,
          indentLevel: indentLevel ?? 2,
        );

  /// Creates a [LogCardPlayed] from a JSON map.
  factory LogCardPlayed.fromJson(Map<String, dynamic> json) =>
      _$LogCardPlayedFromJson(json);

  /// The key for the card that has been played.
  final GameCard cardKey;

  /// The playerIndex of the player who played the card.
  final int playerIndex;

  /// Whether playing of this card is hidden to the other players.
  final bool isHidden;

  @override
  Map<String, dynamic> toJson() => _$LogCardPlayedToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) {
    var trKey = localizedKey;
    if (isHidden) {
      final isPlayedThisRound =
          (game as TBGame).logEntries[game.currentRound]?.contains(this) ??
              false;
      final suffix = isPlayedThisRound ? 'ThisRound' : 'Before';
      trKey = '${localizedKey}Hidden$suffix';
    }
    return TrObject(trKey, richTrObjects: _getRichTrObjects());
  }

  List<RichTrObject> _getRichTrObjects() => [
        RichTrObject(
          RichTrType.player,
          value: playerIndex,
        ),
        RichTrObject(TBRichTrType.card, value: cardKey),
      ];
}
