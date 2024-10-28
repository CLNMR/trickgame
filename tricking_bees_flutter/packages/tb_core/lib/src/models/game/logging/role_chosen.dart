import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../roles/role_catalog.dart';
import '../../../util/tb_rich_tr_object_type.dart';
import 'tb_log_entry_type.dart';

part 'role_chosen.g.dart';

@JsonSerializable()

/// Log a player choosing a role.
class LogRoleChosen extends LogEntry {
  /// Creates a [LogRoleChosen].
  LogRoleChosen({
    required this.playerIndex,
    required this.role,
    int? indentLevel,
  }) : super(
          entryType: TBLogEntryType.roleChosen,
          indentLevel: indentLevel ?? 0,
        );

  /// Creates a [LogRoleChosen] from a JSON map.
  factory LogRoleChosen.fromJson(Map<String, dynamic> json) =>
      _$LogRoleChosenFromJson(json);

  /// The player that chooses the role
  final int playerIndex;

  /// The role that was chosen.
  final RoleCatalog role;

  @override
  Map<String, dynamic> toJson() => _$LogRoleChosenToJson(this)
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
          RichTrObject(TBRichTrType.role, value: role),
        ],
      );
}
