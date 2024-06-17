// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_start.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogRoundStart _$LogRoundStartFromJson(Map json) => LogRoundStart(
      round: (json['round'] as num).toInt(),
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogRoundStartToJson(LogRoundStart instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'round': instance.round,
    };
