import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:json_annotation/json_annotation.dart';

import 'tb_log_entry_type.dart';

part 'skip_turn.g.dart';

@JsonSerializable()

/// Log whenever a player skips their turn.
class LogSkipTurn extends LogEntry {
  /// Creates a [LogSkipTurn].
  LogSkipTurn({
    required this.playerIndex,
    this.isCardSkip = false,
    int? indentLevel,
  }) : super(
          entryType: TBLogEntryType.skipTurn,
          indentLevel: indentLevel ?? 2,
        );

  /// Creates a [LogSkipTurn] from a JSON map.
  factory LogSkipTurn.fromJson(Map<String, dynamic> json) =>
      _$LogSkipTurnFromJson(json);

  /// The player that skipped their turn.
  final int playerIndex;

  /// Whether the card play was deliberately skipped.
  final bool isCardSkip;

  @override
  Map<String, dynamic> toJson() => _$LogSkipTurnToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) => TrObject(
        localizedKey,
        richTrObjects: [RichTrObject(RichTrType.player, value: playerIndex)],
      );
}
