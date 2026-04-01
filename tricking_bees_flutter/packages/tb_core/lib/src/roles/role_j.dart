import 'role.dart';

/// They play their cards hidden.
class RoleJ extends Role {
  /// Creates a [RoleJ].
  RoleJ() : super(key: .roleJ);

  @override
  bool get playsCardHidden => true;
}
