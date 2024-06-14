import 'package:json_annotation/json_annotation.dart';

import '../../../wrapper/rich_tr_object.dart';
import '../../../wrapper/rich_tr_object_type.dart';
import '../../../wrapper/tr_object.dart';
import '../game.dart';
import 'log_entry.dart';
import 'log_entry_type.dart';

part 'start_of_game.g.dart';

@JsonSerializable()

/// An entry to a card that the solo player chooses.
class LogStartOfGame extends LogEntry {
  /// Creates a [LogStartOfGame].
  LogStartOfGame({
    int? indentLevel,
  }) : super(
          entryType: LogEntryType.startOfGame,
          indentLevel: indentLevel ?? 0,
        );

  /// Creates a [LogStartOfGame] from a JSON.
  factory LogStartOfGame.fromJson(Map<String, dynamic> json) =>
      _$LogStartOfGameFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LogStartOfGameToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) => TrObject(
        localizedKey,
        richTrObjects: [
          ...[0, 1, 2].map(
            (i) => RichTrObject(
              RichTrType.player,
              value: i,
              keySuffix: '${i + 1}',
            ),
          ),
          RichTrObject(
            RichTrType.cardList,
            value: game.cards[3],
          ),
        ],
        namedArgs: {'gameId': game.gameId.toString()},
      );
}
