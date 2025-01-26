import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';

import '../roles/role_catalog.dart';

/// A class that represents a translation object.
class TBTrObject extends TrObject {
  /// Creates a new translation object.
  TBTrObject(
    super.text, {
    super.args,
    super.namedArgs,
    super.gender,
    super.namedArgsTrObjects,
    super.richTrObjects,
    this.roleKey,
  });

  /// The associated event key, if any.
  RoleCatalog? roleKey;
}
