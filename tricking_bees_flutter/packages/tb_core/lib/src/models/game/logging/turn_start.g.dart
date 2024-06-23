// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turn_start.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogTrickWon _$LogTrickWonFromJson(Map json) => LogTrickWon(
      playerIndex: (json['playerIndex'] as num).toInt(),
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogTrickWonToJson(LogTrickWon instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'playerIndex': instance.playerIndex,
    };
