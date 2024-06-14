import 'package:json_annotation/json_annotation.dart';

import '../../../wrapper/tr_object.dart';
import '../game.dart';
import 'log_entry_type.dart';

part 'log_entry.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: false)

/// An entry to log what has happened in the game.
abstract class LogEntry {
  /// Creates a [LogEntry].
  LogEntry({
    required this.entryType,
    required this.indentLevel,
    // this.coords = const [],
  });

  /// Creates a [LogEntry] from JSON data.
  factory LogEntry.fromJson(Map<String, dynamic> json) {
    final entryType = LogEntryType.values
        .firstWhere((entryType) => entryType.name == json['entryType']);
    return entryType.fromJson(json);
  }

  /// The entryType for this log entry
  final LogEntryType entryType;

  /// The indentation level of the log event.
  int indentLevel;

  /// Converts the [LogEntry] to JSON data.
  Map<String, dynamic> toJson();

  /// The log entry key.
  String get localizedKey => 'LOG:${entryType.name}';

  /// The description of the log entry, to be reimplemented.
  TrObject getDescription(Game game);

  /// Shows the event display, to be reimplemented.
  Future<void> showEventDisplay(
    Game game,
    Function(
      TrObject title,
      TrObject message,
    ) displayEvent,
    Function() incrementLogDisplayCount,
  ) async {
    incrementLogDisplayCount();
  }
}
