// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RoutingGenerator
// **************************************************************************

// ignore_for_file: directives_ordering, prefer_relative_imports
// ignore_for_file: prefer_const_constructors
import 'package:go_router/go_router.dart';
import 'package:tricking_bees/screens/game_screen.dart';

/// The path and route of the screen.
extension GameScreenRouting on GameScreen {
  /// The path of the screen.
  static const String path = '/game';

  /// The parameter of the screen.
  static const String param = 'gameId';

  /// The route of the screen.
  static GoRoute route = GoRoute(
    path: '$path/:$param',
    name: path,
    builder: (
      context,
      state,
    ) =>
        GameScreen(
      gameId: state.pathParameters[param]!,
    ),
  );
}
