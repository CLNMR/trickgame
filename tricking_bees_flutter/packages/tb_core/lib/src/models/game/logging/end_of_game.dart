import 'package:json_annotation/json_annotation.dart';

import '../../../wrapper/rich_tr_object.dart';
import '../../../wrapper/rich_tr_object_type.dart';
import '../../../wrapper/tr_object.dart';
import '../game.dart';
import 'log_entry.dart';
import 'log_entry_type.dart';

part 'end_of_game.g.dart';

@JsonSerializable()

/// An entry to a card that the solo player chooses.
class LogEndOfGame extends LogEntry {
  /// Creates a [LogEndOfGame].
  LogEndOfGame({
    int? indentLevel,
  }) : super(
          entryType: LogEntryType.endOfGame,
          indentLevel: indentLevel ?? 0,
        );

  /// Creates a [LogEndOfGame] from a JSON.
  factory LogEndOfGame.fromJson(Map<String, dynamic> json) =>
      _$LogEndOfGameFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LogEndOfGameToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) => TrObject(
        localizedKey,
        richTrObjects: [
          RichTrObject(
            RichTrType.playerList,
            value: game.playerPoints.entries.toList()
              ..sort((a, b) => a.value.compareTo(b.value))
              ..map((e) => e.key).toList(),
            keySuffix: 'Ranking',
          ),
        ],
        namedArgs: {'gameId': game.gameId.toString()},
      );
}
