import 'package:json_annotation/json_annotation.dart';

import '../../../wrapper/rich_tr_object.dart';
import '../../../wrapper/rich_tr_object_type.dart';
import '../../../wrapper/tr_object.dart';
import '../game.dart';
import 'log_entry.dart';
import 'log_entry_type.dart';

part 'turn_start.g.dart';

@JsonSerializable()

///
class LogTurnStart extends LogEntry {
  /// Creates a [LogTurnStart].
  LogTurnStart({
    required this.playerIndex,
    int? indentLevel,
  }) : super(
          entryType: LogEntryType.turnStart,
          indentLevel: indentLevel ?? 1,
        );

  /// Creates a [LogTurnStart] from a JSON map.
  factory LogTurnStart.fromJson(Map<String, dynamic> json) =>
      _$LogTurnStartFromJson(json);

  /// The playerIndex of the player starting their turn.
  final int playerIndex;

  @override
  Map<String, dynamic> toJson() => _$LogTurnStartToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) => TrObject(
        localizedKey,
        richTrObjects: [
          RichTrObject(RichTrType.player, value: playerIndex),
        ],
      );

  @override
  Future<void> showEventDisplay(
    Game game,
    Function(
      TrObject title,
      TrObject message,
    ) displayEvent,
    Function() incrementLogDisplayCount,
  ) async {
    final playerInfo = game.currentPlayer;
    await displayEvent(
      TrObject("${playerInfo.displayName}'s turn starts"),
      TrObject(''),
    );
    incrementLogDisplayCount();
  }
}
