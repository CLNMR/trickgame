// ignore_for_file: public_member_api_docs

import 'no_role.dart';
import 'role.dart';
import 'role_a.dart';
import 'role_b.dart';
import 'role_c.dart';
import 'role_d.dart';
import 'role_e.dart';
import 'role_f.dart';
import 'role_g.dart';
import 'role_h.dart';
import 'role_i.dart';
import 'role_j.dart';

/// All roles available in the game.
enum RoleCatalog {
  roleA(RoleA.new),
  roleB(RoleB.new),
  roleC(RoleC.new),
  roleD(RoleD.new),
  roleE(RoleE.new),
  roleF(RoleF.new),
  roleG(RoleG.new),
  roleH(RoleH.new),
  roleI(RoleI.new),
  roleJ(RoleJ.new),
  noRole(NoRole.new);

  const RoleCatalog(this.roleConstructor);

  /// The constructor of the role.
  final Role Function() roleConstructor;

  /// The localized name of the role.
  String get locName => 'ROLE:NAME:$name';

  /// The localized description of the benefits for the role.
  String get descBenefits => 'ROLE:DESC:BEN:$name';

  /// The localized description of the point scheme for the role.
  String get descPointScheme => 'ROLE:DESC:PTS:$name';

  /// The image of the role. For BurningWall it's the same image for all sides.
  String get imagePath => 'assets/images/events/$name.png';
}
