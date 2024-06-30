import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../util/app_gradients.dart';
import '../../util/context_extension.dart';
import '../own_text.dart';

/// A list view for log entries.
class LogEntryListDisplay extends ConsumerStatefulWidget {
  /// Creates a [LogEntryListDisplay].
  const LogEntryListDisplay({
    super.key,
    required this.game,
  });

  /// The game for which the logEntries should be shown.
  final Game game;

  @override
  ConsumerState<LogEntryListDisplay> createState() =>
      _LogEntryListDisplayState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}

class _LogEntryListDisplayState extends ConsumerState<LogEntryListDisplay> {
  bool _isMinimized = false;

  Map<int, bool> expandedState = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _scrollToBottom(force: true);
    });
  }

  @override
  void didUpdateWidget(LogEntryListDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _scrollToBottom();
    });
  }

  /// Scrolls to the bottom of the list.
  Future<void> _scrollToBottom({bool force = false}) async {
    final isAtBottom = _scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 30;
    if (_scrollController.hasClients && (isAtBottom || force)) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent, //+ 300,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(),
          gradient: AppGradients.indigoToYellow,
        ),
        child: _isMinimized ? _buildMaximizeButton() : _buildMaximizedLog(),
      );

  // TODO: Introduce animation to switch the states, and maybe the number of
  // unseen (new) log messages for the user as an overlayed number.
  Widget _buildMaximizeButton() => IconButton(
        onPressed: () {
          setState(() {
            _isMinimized = false;
          });
        },
        icon: const Icon(Icons.chevron_left),
      );

  Widget _buildMinimizeButton() => IconButton(
        onPressed: () {
          setState(() {
            _isMinimized = true;
          });
        },
        icon: const Icon(Icons.chevron_right),
      );

  Widget _buildMaximizedLog() {
    final logEntries = widget.game.logEntries;
    return Column(
      children: [
        _buildHeader(),
        const Divider(
          height: 2,
          thickness: 2,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: _buildEntryList(logEntries),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            _buildMinimizeButton(),
            const OwnText(
              text: 'LOG:boxTitle',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
              iconSize: 12,
              icon: const Icon(Icons.keyboard_double_arrow_down),
              onPressed: () async => _scrollToBottom(force: true),
            ),
          ],
        ),
      );

  Widget _buildEntryList(Map<int, List<LogEntry>> logEntries) =>
      ListView.builder(
        itemCount: logEntries.length + 1,
        controller: _scrollController,
        itemBuilder: (context, round) {
          final entries = logEntries[round - 1]!;
          return _buildExpansionPanelForRound(round - 1, entries);
        },
      );

  Widget _buildExpansionPanelForRound(
    RoundNumber round,
    List<LogEntry> logEntries,
  ) {
    final isExpanded = expandedState[round] ??
        [widget.game.currentRound, widget.game.currentRound - 1]
            .contains(round);
    final expanseController = ExpandableController(initialExpanded: isExpanded);
    expanseController.addListener(() {
      setState(() {
        // TODO: Do not let the player open previous rounds except for subgame
        // starts (as long as the game isn't finished)
        expandedState[round] = expanseController.expanded;
      });
    });
    return ExpandableNotifier(
      controller: expanseController,
      child: ScrollOnExpand(
        scrollOnCollapse: false,
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            useInkWell: true,
            iconSize: 15,
            iconPadding: EdgeInsets.all(3),
          ),
          header: _buildHeaderForRound(round),
          collapsed: const SizedBox(),
          expanded: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: ListBody(
                children: logEntries.map(_buildSingleLogEntryDisplay).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderForRound(RoundNumber round) => OwnText(
        trObject: round == -1
            ? TrObject('LOG:headerGameStart')
            : Game.roundStartsSubgame(round)
                ? TrObject(
                    'LOG:headerSubgameStart',
                    namedArgs: {
                      'subgame': Game.getSubgameNumForRound(round).toString(),
                      'subgameNum': widget.game.subgameNum.toString(),
                    },
                  )
                : TrObject(
                    'LOG:headerSubgameRound',
                    namedArgs: {
                      'round': Game.getSubRoundNumber(round).toString(),
                    },
                  ),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildSingleLogEntryDisplay(LogEntry logEntry) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: logEntry.indentLevel.toDouble() * 6,
              top: 5,
              right: 2,
            ),
            child: const Icon(Icons.circle, size: 6, color: Colors.black),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText.rich(
                  context.trFromObjectToTextSpan(
                    logEntry.getDescription(widget.game),
                    widget.game.shortenedPlayerNames,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Map<int, bool>>('expandedState', expandedState),
    );
  }
}
