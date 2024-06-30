// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_played.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogCardPlayed _$LogCardPlayedFromJson(Map json) => LogCardPlayed(
      cardKey:
          GameCard.fromJson(Map<String, dynamic>.from(json['cardKey'] as Map)),
      playerIndex: (json['playerIndex'] as num).toInt(),
      isHidden: json['isHidden'] as bool? ?? false,
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogCardPlayedToJson(LogCardPlayed instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'cardKey': instance.cardKey.toJson(),
      'playerIndex': instance.playerIndex,
      'isHidden': instance.isHidden,
    };
