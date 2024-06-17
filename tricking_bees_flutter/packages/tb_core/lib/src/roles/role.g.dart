// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map json) => Role(
      key: $enumDecode(_$RoleCatalogEnumMap, json['key']),
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'key': _$RoleCatalogEnumMap[instance.key]!,
    };

const _$RoleCatalogEnumMap = {
  RoleCatalog.noRole: 'noRole',
};
