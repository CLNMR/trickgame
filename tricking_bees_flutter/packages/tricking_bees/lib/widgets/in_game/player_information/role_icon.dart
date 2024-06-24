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
    required this.roleKey,
    this.isChoosable = true,
  });

  /// The role to be displayed.
  final RoleCatalog roleKey;

  /// Whether the role is currently choosable.
  final bool isChoosable;

  @override
  Widget build(BuildContext context) => Tooltip(
        message:
            '${roleKey.descBenefits.tr()}\n${roleKey.descPointScheme.tr()}',
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: SizedBox(
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: OwnText(
                      text: roleKey.locName,
                      ellipsis: true,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildSmallImage(roleKey.imagePathBenefits),
                      if (!isChoosable)
                        Icon(
                          Icons.lock,
                          color: Colors.deepOrangeAccent[700]!.withOpacity(0.7),
                        ),
                    ],
                  ),
                  _buildSmallImage(roleKey.imagePathPoints),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildSmallImage(String imagePath) => ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill,
          width: 35,
          height: 35,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<RoleCatalog>('roleKey', roleKey))
      ..add(DiagnosticsProperty<bool>('isChoosable', isChoosable));
  }
}
