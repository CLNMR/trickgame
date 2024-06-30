import 'package:json_annotation/json_annotation.dart';

import '../../../wrapper/rich_tr_object.dart';
import '../../../wrapper/rich_tr_object_type.dart';
import '../../../wrapper/tr_object.dart';
import '../game.dart';
import 'log_entry.dart';
import 'log_entry_type.dart';

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
          entryType: LogEntryType.roundStartPlayOrder,
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
