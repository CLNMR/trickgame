import 'package:json_annotation/json_annotation.dart';

import '../../../wrapper/rich_tr_object.dart';
import '../../../wrapper/rich_tr_object_type.dart';
import '../../../wrapper/tr_object.dart';
import '../game.dart';
import 'log_entry.dart';
import 'log_entry_type.dart';

part 'faction_chosen.g.dart';

@JsonSerializable()

/// Log a player choosing a faction for a card (e.g. for Swamp)
class LogFactionChosen extends LogEntry {
  /// Creates a [LogFactionChosen].
  LogFactionChosen({
    required this.playerIndex,
    required this.factionIndex,
    int? indentLevel,
  }) : super(
          entryType: LogEntryType.factionChosen,
          indentLevel: indentLevel ?? 0,
        );

  /// Creates a [LogFactionChosen] from a JSON map.
  factory LogFactionChosen.fromJson(Map<String, dynamic> json) =>
      _$LogFactionChosenFromJson(json);

  /// The player that chooses the faction
  final int playerIndex;

  /// The faction that was chosen.
  final int factionIndex;

  @override
  Map<String, dynamic> toJson() => _$LogFactionChosenToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) => TrObject(
        localizedKey,
        richTrObjects: [
          RichTrObject(
            RichTrType.player,
            value: playerIndex,
          ),
          RichTrObject(RichTrType.faction, value: factionIndex),
        ],
      );
}
