// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faction_chosen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogFactionChosen _$LogFactionChosenFromJson(Map json) => LogFactionChosen(
      playerIndex: (json['playerIndex'] as num).toInt(),
      factionIndex: (json['factionIndex'] as num).toInt(),
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogFactionChosenToJson(LogFactionChosen instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'playerIndex': instance.playerIndex,
      'factionIndex': instance.factionIndex,
    };
