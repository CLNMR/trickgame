// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cards_dealt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogCardsDealt _$LogCardsDealtFromJson(Map json) => LogCardsDealt(
      cardAmount: (json['cardAmount'] as num).toInt(),
      playerIndex: (json['playerIndex'] as num).toInt(),
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogCardsDealtToJson(LogCardsDealt instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'cardAmount': instance.cardAmount,
      'playerIndex': instance.playerIndex,
    };
