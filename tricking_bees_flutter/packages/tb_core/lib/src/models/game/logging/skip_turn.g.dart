// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skip_turn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogSkipTurn _$LogSkipTurnFromJson(Map json) => LogSkipTurn(
      playerIndex: json['playerIndex'] as int,
      isCardSkip: json['isCardSkip'] as bool? ?? false,
      indentLevel: json['indentLevel'] as int?,
    );

Map<String, dynamic> _$LogSkipTurnToJson(LogSkipTurn instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'playerIndex': instance.playerIndex,
      'isCardSkip': instance.isCardSkip,
    };
