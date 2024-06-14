import 'package:json_annotation/json_annotation.dart';

part 'game_area.g.dart';

@JsonSerializable()

/// The game board with all the hexagonal cells.
class GameArea {
  /// Creates a new board.
  GameArea();

  /// Creates a [GameArea] from JSON data.
  factory GameArea.fromJson(Map<String, dynamic> json) =>
      _$GameAreaFromJson(json);

  /// Converts the [GameArea] to JSON data.
  Map<String, dynamic> toJson() => _$GameAreaToJson(this);
}
