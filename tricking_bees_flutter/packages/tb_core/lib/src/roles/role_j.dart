import 'role.dart';
import 'role_catalog.dart';

/// They play their cards hidden.
class RoleJ extends Role {
  /// Creates a [RoleJ].
  RoleJ() : super(key: RoleCatalog.roleJ);

  @override
  bool get playsCardHidden => true;
}
