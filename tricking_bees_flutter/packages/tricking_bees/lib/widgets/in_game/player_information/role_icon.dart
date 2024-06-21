import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tb_core/tb_core.dart';

import '../../own_text.dart';

/// A widget representing a role with an icon and a name.
class RoleIcon extends StatelessWidget {
  /// Creates an [RoleIcon].
  const RoleIcon({
    super.key,
    required this.role,
  });

  /// The role to be displayed.
  final Role role;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: role.key.descBenefits.tr(),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Image.asset(role.key.imagePath),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: OwnText(text: role.key.name),
              ),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Role>('role', role));
  }
}
