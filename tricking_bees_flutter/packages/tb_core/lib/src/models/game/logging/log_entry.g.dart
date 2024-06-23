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
  LogEntryType.roundStartPlayOrder: 'roundStartPlayOrder',
  LogEntryType.turnStart: 'turnStart',
  LogEntryType.cardPlayed: 'cardPlayed',
  LogEntryType.roleChosen: 'roleChosen',
  LogEntryType.skipTurn: 'skipTurn',
  LogEntryType.subgameStarts: 'subgameStarts',
};
