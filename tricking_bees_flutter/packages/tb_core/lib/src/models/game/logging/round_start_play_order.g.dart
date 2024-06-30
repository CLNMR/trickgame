// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_start_play_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogRoundStartPlayOrder _$LogRoundStartPlayOrderFromJson(Map json) =>
    LogRoundStartPlayOrder(
      round: (json['round'] as num).toInt(),
      playOrder: (json['playOrder'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogRoundStartPlayOrderToJson(
        LogRoundStartPlayOrder instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'round': instance.round,
      'playOrder': instance.playOrder,
    };
