part of 'game.dart';

/// Handles the events for each round of the game.
extension GameEventHandlingExt on Game {
  /// Retrieve all roles that are currently active in this game.
  List<Role> get currentRoles => roles.isEmpty
      ? [Role.fromEventType(RoleCatalog.noRole)]
      : roles.map(Role.fromEventType).toList();
}
