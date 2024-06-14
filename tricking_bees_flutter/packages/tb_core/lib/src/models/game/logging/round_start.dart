import 'package:json_annotation/json_annotation.dart';

import '../../../roles/role_catalog.dart';
import '../../../wrapper/rich_tr_object.dart';
import '../../../wrapper/rich_tr_object_type.dart';
import '../../../wrapper/tr_object.dart';
import '../game.dart';
import 'log_entry.dart';
import 'log_entry_type.dart';

part 'round_start.g.dart';

@JsonSerializable()

///
class LogRoundStart extends LogEntry {
  /// Creates a [LogRoundStart].
  LogRoundStart({
    required this.round,
    int? indentLevel,
  }) : super(
          entryType: LogEntryType.roundStart,
          indentLevel: indentLevel ?? 0,
        );

  /// Creates a [LogRoundStart] from a JSON map.
  factory LogRoundStart.fromJson(Map<String, dynamic> json) =>
      _$LogRoundStartFromJson(json);

  /// The round number of the round that is started.
  final int round;

  @override
  Map<String, dynamic> toJson() => _$LogRoundStartToJson(this)
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
            RichTrType.event,
            value: game.currentRoles.firstOrNull?.key ??
                RoleCatalog.noRole, // TODO: This is a temporary solution.
          ),
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
    final currentEvent =
        game.currentRoles.first; // TODO: This is a temporary solution.
    await displayEvent(
      TrObject('New Round: ${currentEvent.key.locName}'),
      TrObject(currentEvent.key.description),
    );
    incrementLogDisplayCount();
  }
}
