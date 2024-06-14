import '../../tb_core.dart';

/// Sorts the given cards list first by strenngth and then by localized name.
List<GameCard> sortCardsList(List<GameCard> cards) =>
    cards..sort(_compareCards);

int _compareCards(GameCard card1, GameCard card2) {
  // TODO: Implement good sorting.
  return 1;
}
