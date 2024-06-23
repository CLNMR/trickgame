import 'package:json_annotation/json_annotation.dart';

import '../../../cards/game_card.dart';
import '../../../wrapper/rich_tr_object.dart';
import '../../../wrapper/rich_tr_object_type.dart';
import '../../../wrapper/tr_object.dart';
import '../game.dart';
import 'log_entry.dart';
import 'log_entry_type.dart';

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
          entryType: LogEntryType.subgameStarts,
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
            value: game.subgameNum,
            keySuffix: 'Tot',
          ),
          RichTrObject(
            RichTrType.card,
            value: trumpCard,
          ),
        ],
      );

  // @override
  // Future<void> showEventDisplay(
  //   Game game,
  //   Function(
  //     TrObject title,
  //     TrObject message,
  //   ) displayEvent,
  //   Function() incrementLogDisplayCount,
  // ) async {
  //   final currentEvent =
  //       game.currentRoles.first; // TODO: This is a temporary solution.
  //   await displayEvent(
  //     TrObject('New Round: ${currentEvent.key.locName}'),
  //     TrObject(currentEvent.key.descBenefits),
  //   );
  //   incrementLogDisplayCount();
  // }
}
