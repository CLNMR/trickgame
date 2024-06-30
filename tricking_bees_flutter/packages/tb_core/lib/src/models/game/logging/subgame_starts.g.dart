// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subgame_starts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogSubgameStarts _$LogSubgameStartsFromJson(Map json) => LogSubgameStarts(
      subgame: (json['subgame'] as num).toInt(),
      trumpCard: GameCard.fromJson(
          Map<String, dynamic>.from(json['trumpCard'] as Map)),
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogSubgameStartsToJson(LogSubgameStarts instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'subgame': instance.subgame,
      'trumpCard': instance.trumpCard.toJson(),
    };
