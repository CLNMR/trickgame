import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../cards/card_color.dart';
import '../../../util/tb_rich_tr_object_type.dart';
import 'tb_log_entry_type.dart';

part 'trump_chosen.g.dart';

@JsonSerializable()

/// Log a player choosing a role.
class LogTrumpChosen extends LogEntry {
  /// Creates a [LogTrumpChosen].
  LogTrumpChosen({
    required this.playerIndex,
    required this.chosenColor,
    int? indentLevel,
  }) : super(
          entryType: TBLogEntryType.trumpChosen,
          indentLevel: indentLevel ?? 0,
        );

  /// Creates a [LogTrumpChosen] from a JSON map.
  factory LogTrumpChosen.fromJson(Map<String, dynamic> json) =>
      _$LogTrumpChosenFromJson(json);

  /// The player that chooses the other player.
  final int playerIndex;

  /// The player that was chosen.
  final CardColor chosenColor;

  @override
  Map<String, dynamic> toJson() => _$LogTrumpChosenToJson(this)
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
          RichTrObject(TBRichTrType.color, value: chosenColor),
        ],
      );
}
