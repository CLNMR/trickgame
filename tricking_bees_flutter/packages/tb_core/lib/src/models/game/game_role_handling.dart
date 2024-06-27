part of 'game.dart';

/// Handles the events for each round of the game.
extension GameEventHandlingExt on Game {
  /// Retrieve all roles that are currently active in this game.
  List<Role> get currentRoles => players.map((e) => e.role).toList();

  /// Assigns the given Role to the current player and advances the game to the
  /// next player.
  Future<void> chooseRole(RoleCatalog roleKey) async {
    currentPlayer.roleKey = roleKey;
    addLogEntry(LogRoleChosen(playerIndex: currentTurnIndex, role: roleKey));
    incrementTurnIndex();
    if (currentTurnIndex == 0) {
      await finishRoleSelection(firstTime: true);
    } else {
      await save();
    }
  }

  /// Checks whether the current player can choose a role.
  bool canChooseRole(RoleCatalog role, YustUser? user) =>
      (user != null) &&
      currentPlayer.id == getPlayer(user).id &&
      inputRequirement == InputRequirement.selectRole &&
      !currentRoles.map((e) => e.key).contains(role);

  /// Finishes the role selection and goes through the remaining players to
  /// resolve their start-of-game effects.
  Future<void> finishRoleSelection({bool firstTime = false}) async {
    if (!firstTime) incrementTurnIndex();
    inputRequirement = InputRequirement.selectRole;
    // Iterate through the players and see whether the roles require the player
    // to do something at the start of the game.
    while (currentTurnIndex != 0) {
      currentPlayer.role.onStartOfSubgame(this);
      if (inputRequirement != InputRequirement.selectRole) {
        await save();
        return;
      }
      incrementTurnIndex();
    }
    await endRoleSelectionAndStartTrickGame();
  }

  /// Finishes the role selection and advances the game to the next player.
  Future<void> endRoleSelectionAndStartTrickGame() async {
    gameState = GameState.playingTricks;
    playOrder = List.generate(
      playerNum,
      (index) => (index + currentSubgame - 1) % playerNum,
    );
    await nextPlayer(doNotIncrement: true);
  }

  /// Select a trump color.
  Future<void> selectTrumpColor(CardColor trump) async {
    setFlag(_overridingTrumpColorKey, trump.toString());
    await finishRoleSelection();
  }

  /// Retrieve the first player with the given role.
  int? getFirstPlayerWithRole(RoleCatalog roleKey) =>
      players.indexWhere((e) => e.roleKey == roleKey);

  /// Sets a flag for the current card or event.
  void setFlag(String key, dynamic value) {
    var val = value;
    if (value is Map) {
      // print(val); // The problem seems to be that e.g. {1: (2, false)} is not
      // json serializable since the tuple is not json serializable by default.
      // We'll need to write a custom serializer for this.
      val = Map<String, dynamic>.from(value);
    }
    flags[key] = val;
  }

  /// Sets the flag for a map mapping a integers to tuples of integers/booleans.
  void setMapTupleFlag(String key, Map<int, (int, bool)> value) {
    final jsonValue = value.map(
      (k, v) => MapEntry(k.toString(), [v.$1.toString(), v.$2.toString()]),
    );
    setFlag(key, jsonValue);
  }

  /// Gets the flag for a map mapping a integers to tuples of integers/booleans.
  Map<int, (int, bool)>? getMapTupleFlag(String key) {
    final jsonValue = getFlagMap<String, List<dynamic>>(key);
    if (jsonValue == null) return null;
    return jsonValue.map(
      (k, v) => MapEntry(int.parse(k), (int.parse(v[0]), bool.parse(v[1]))),
    );
  }

  /// Deletes a flag for the current card or event.
  void deleteFlag(String key) {
    if (flags.containsKey(key)) flags[key] = FieldValue.delete();
  }

  /// Checks if a flag is currently registered.
  bool checkForFlag(String key) => flags.containsKey(key);

  /// Gets a flag for the current card or event.
  T? getFlag<T>(String key) {
    if (flags[key] == null) return null;
    return flags[key] as T?;
  }

  /// Gets a flag for the current card or event.
  List<T>? getFlagList<T>(String key) {
    if (flags[key] == null) return null;
    if (flags[key] is! List) {
      throw Exception(
        // ignore: avoid_dynamic_calls
        'Value must be a list, not ${flags[key].runtimeType}',
      );
    }
    return List<T>.from(flags[key]);
    // (flags[key] as List).cast<T>();
  }

  /// Gets a flag for the current card or event.
  Map<A, B>? getFlagMap<A, B>(String key) {
    if (flags[key] == null) return null;
    if (flags[key] is! Map) {
      throw Exception(
        // ignore: avoid_dynamic_calls
        'Value must be a map, not ${flags[key].runtimeType}',
      );
    }
    return (flags[key] as Map).cast<A, B>();
  }
}
