import '../models/game_event_handler.dart';
import 'role_catalog.dart';

/// A role of the game.
abstract class Role extends GameEventHandler {
  /// Creates an [Role].
  Role({required this.key});

  /// Creates an [Role] from an [RoleCatalog].
  factory Role.fromEventType(RoleCatalog roleType) =>
      roleType.roleConstructor();

  /// The key of the role.
  final RoleCatalog key;

  /// The base key for the status of the role.
  String get basicStatusKey => 'STATUS:SPECIAL:${key.name}';
}
