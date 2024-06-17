// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turn_start.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogTurnStart _$LogTurnStartFromJson(Map json) => LogTurnStart(
      playerIndex: (json['playerIndex'] as num).toInt(),
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogTurnStartToJson(LogTurnStart instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'playerIndex': instance.playerIndex,
    };
