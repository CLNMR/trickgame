import 'package:json_annotation/json_annotation.dart';

import '../../../roles/role_catalog.dart';
import '../../../wrapper/rich_tr_object.dart';
import '../../../wrapper/rich_tr_object_type.dart';
import '../../../wrapper/tr_object.dart';
import '../game.dart';
import 'log_entry.dart';
import 'log_entry_type.dart';

part 'player_chosen.g.dart';

@JsonSerializable()

/// Log a player choosing a role.
class LogPlayerChosen extends LogEntry {
  /// Creates a [LogPlayerChosen].
  LogPlayerChosen({
    required this.playerIndex,
    required this.playerChosenIndex,
    required this.roleKey,
    int? indentLevel,
  }) : super(
          entryType: LogEntryType.playerChosen,
          indentLevel: indentLevel ?? 0,
        );

  /// Creates a [LogPlayerChosen] from a JSON map.
  factory LogPlayerChosen.fromJson(Map<String, dynamic> json) =>
      _$LogPlayerChosenFromJson(json);

  /// The player that chooses the other player.
  final int playerIndex;

  /// The player that was chosen.
  final int playerChosenIndex;

  /// The role that was chosen.
  final RoleCatalog roleKey;

  @override
  Map<String, dynamic> toJson() => _$LogPlayerChosenToJson(this)
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
          RichTrObject(
            RichTrType.player,
            value: playerChosenIndex,
            keySuffix: 'Chosen',
          ),
          RichTrObject(RichTrType.role, value: roleKey),
        ],
      );
}
