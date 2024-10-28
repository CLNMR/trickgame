import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:test/test.dart';

void main() {
  test('getUniqueStartSubstrings', () {
    final test = ['Player 1', 'Player 2', 'Colin'];
    expect(getUniqueStartSubstrings(test), ['Player 1', 'Player 2', 'C']);
  });
  test('getUniqueStartSubstrings2', () {
    final test = [
      'Alan',
      'Alastair',
      'alex',
      'Henry',
      'Holger',
      'Johannes',
      'Klaus',
    ];
    expect(getUniqueStartSubstrings(test), [
      'Alan',
      'Alas',
      'ale',
      'He',
      'Ho',
      'J',
      'K',
    ]);
  });
}
