// ignore_for_file: public_member_api_docs

import 'no_role.dart';
import 'role.dart';

/// All roles available in the game.
enum RoleCatalog {
  noRole(NoRole.new);

  const RoleCatalog(this.roleConstructor);

  /// The constructor of the role.
  final Role Function() roleConstructor;

  /// The localized name of the role.
  String get locName => 'ROLE:NAME:$name';

  /// The localized description of the role.
  String get description => 'ROLE:DESC:$name';

  /// The image of the role. For BurningWall it's the same image for all sides.
  String get imagePath => 'assets/images/events/$name.png';
}
