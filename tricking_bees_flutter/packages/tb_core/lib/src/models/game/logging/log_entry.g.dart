// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$LogEntryToJson(LogEntry instance) => <String, dynamic>{
      'entryType': _$LogEntryTypeEnumMap[instance.entryType]!,
      'indentLevel': instance.indentLevel,
      'localizedKey': instance.localizedKey,
    };

const _$LogEntryTypeEnumMap = {
  LogEntryType.startOfGame: 'startOfGame',
  LogEntryType.subgameStarts: 'subgameStarts',
  LogEntryType.roundStartPlayOrder: 'roundStartPlayOrder',
  LogEntryType.trickWon: 'trickWon',
  LogEntryType.cardPlayed: 'cardPlayed',
  LogEntryType.cardsDealt: 'cardsDealt',
  LogEntryType.roleChosen: 'roleChosen',
  LogEntryType.playerChosen: 'playerChosen',
  LogEntryType.trumpChosen: 'trumpChosen',
  LogEntryType.skipTurn: 'skipTurn',
  LogEntryType.pointsAwarded: 'pointsAwarded',
  LogEntryType.endOfGame: 'endOfGame',
};
