import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:json_annotation/json_annotation.dart';

import '../tb_game.dart';
import 'tb_log_entry_type.dart';

part 'turn_start.g.dart';

@JsonSerializable()

///
class LogTrickWon extends LogEntry {
  /// Creates a [LogTrickWon].
  LogTrickWon({
    required this.playerIndex,
    int? indentLevel,
  }) : super(
          entryType: TBLogEntryType.trickWon,
          indentLevel: indentLevel ?? 1,
        );

  /// Creates a [LogTrickWon] from a JSON map.
  factory LogTrickWon.fromJson(Map<String, dynamic> json) =>
      _$LogTrickWonFromJson(json);

  /// The playerIndex of the player that won the trick.
  final int playerIndex;

  @override
  Map<String, dynamic> toJson() => _$LogTrickWonToJson(this)
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
    final playerInfo = (game as TBGame).currentPlayer;
    await displayEvent(
      TrObject("${playerInfo.displayName}'s turn starts"),
      TrObject(''),
    );
    incrementLogDisplayCount();
  }
}
