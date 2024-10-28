import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:json_annotation/json_annotation.dart';

import 'tb_log_entry_type.dart';

part 'round_start_play_order.g.dart';

@JsonSerializable()

///
class LogRoundStartPlayOrder extends LogEntry {
  /// Creates a [LogRoundStartPlayOrder].
  LogRoundStartPlayOrder({
    required this.round,
    required this.playOrder,
    int? indentLevel,
  }) : super(
          entryType: TBLogEntryType.roundStartPlayOrder,
          indentLevel: indentLevel ?? 0,
        );

  /// Creates a [LogRoundStartPlayOrder] from a JSON map.
  factory LogRoundStartPlayOrder.fromJson(Map<String, dynamic> json) =>
      _$LogRoundStartPlayOrderFromJson(json);

  /// The round number of the round that is started.
  final int round;

  /// The order of players.
  final List<int> playOrder;

  @override
  Map<String, dynamic> toJson() => _$LogRoundStartPlayOrderToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) => TrObject(
        localizedKey,
        richTrObjects: [
          RichTrObject(
            RichTrType.number,
            value: round,
          ),
          RichTrObject(
            RichTrType.playerList,
            value: playOrder,
          ),
        ],
      );
}
