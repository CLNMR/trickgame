import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../roles/role_catalog.dart';
import '../../../util/tb_rich_tr_object_type.dart';
import 'tb_log_entry_type.dart';

part 'points_awarded.g.dart';

@JsonSerializable()

/// An entry to a card that the solo player chooses.
class LogPointsAwarded extends LogEntry {
  /// Creates a [LogPointsAwarded].
  LogPointsAwarded({
    int? indentLevel,
    required this.playerIndex,
    required this.roleKey,
    required this.points,
    required this.tricksWon,
  }) : super(
          entryType: TBLogEntryType.pointsAwarded,
          indentLevel: indentLevel ?? 0,
        );

  /// Creates a [LogPointsAwarded] from a JSON.
  factory LogPointsAwarded.fromJson(Map<String, dynamic> json) =>
      _$LogPointsAwardedFromJson(json);

  /// The playerIndex of the player that is awarded the amount of points.
  final PlayerIndex playerIndex;

  /// The role the player has chosen that is awarding the points.
  final RoleCatalog roleKey;

  /// The amount of points the player is awarded.
  final int points;

  /// The amount of tricks the player has won.
  final int tricksWon;

  @override
  Map<String, dynamic> toJson() => _$LogPointsAwardedToJson(this)
    ..addEntries([
      MapEntry('entryType', entryType.name),
    ]);

  @override
  TrObject getDescription(Game game) => TrObject(
        localizedKey,
        richTrObjects: [
          RichTrObject(RichTrType.player, value: playerIndex),
          RichTrObject(TBRichTrType.role, value: roleKey),
          RichTrObject(
            RichTrType.number,
            value: tricksWon,
            keySuffix: 'Tricks',
          ),
          RichTrObject(RichTrType.number, value: points, keySuffix: 'Points'),
        ],
        namedArgs: {'gameId': game.gameId.toString()},
      );
}
