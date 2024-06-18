// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_stack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardStack _$CardStackFromJson(Map json) => CardStack(
      cards: (json['_cards'] as List<dynamic>)
          .map((e) => GameCard.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );

Map<String, dynamic> _$CardStackToJson(CardStack instance) => {
      '_cards': instance._cards.map((e) => e.toJson()).toList(),
    };
