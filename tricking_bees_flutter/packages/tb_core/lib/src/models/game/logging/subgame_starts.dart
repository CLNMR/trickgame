import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../cards/game_card.dart';
import '../../../util/tb_rich_tr_object_type.dart';
import '../tb_game.dart';
import 'tb_log_entry_type.dart';

part 'subgame_starts.g.dart';

@JsonSerializable()

/// Log the start of a new subgame.
class LogSubgameStarts extends LogEntry {
  /// Creates a [LogSubgameStarts].
  LogSubgameStarts({
    required this.subgame,
    required this.trumpCard,
    int? indentLevel,
  }) : super(
          entryType: TBLogEntryType.subgameStarts,
          indentLevel: indentLevel ?? 0,
        );

  /// Creates a [LogSubgameStarts] from a JSON map.
  factory LogSubgameStarts.fromJson(Map<String, dynamic> json) =>
      _$LogSubgameStartsFromJson(json);

  /// The subgame number of the subgame that is started.
  final int subgame;

  /// The order of players.
  final GameCard trumpCard;

  @override
  Map<String, dynamic> toJson() => _$LogSubgameStartsToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) => TrObject(
        localizedKey,
        richTrObjects: [
          RichTrObject(
            RichTrType.number,
            value: subgame,
          ),
          RichTrObject(
            RichTrType.number,
            value: (game as TBGame).subgameNum,
            keySuffix: 'Tot',
          ),
          RichTrObject(
            TBRichTrType.card,
            value: trumpCard,
          ),
        ],
      );
}
