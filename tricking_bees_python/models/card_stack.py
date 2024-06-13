"""A class representing a stack of cards, e.g. the remaining deck or a hand."""

from dataclasses import dataclass, field
from .card import Card, CardColor
import random


@dataclass
class CardStack:
    """A class representing a stack of cards, e.g. the remaining deck or a hand."""

    cards: list[Card] = field(default_factory=list)

    @staticmethod
    def get_highest_number(num_players: int) -> int:
        """Return the highest number on a card that's possible for a given number of players."""
        return 18 if num_players == 6 else 17 if num_players in (4, 5) else 14

    @classmethod
    def from_card_list(cls, card_list: list[Card]) -> "CardStack":
        return cls(cards=card_list)

    @classmethod
    def from_initial_deck(cls, num_players: int) -> "CardStack":
        assert num_players in (
            2,
            3,
            4,
            5,
            6,
        ), f"{num_players} players are not supported"
        highest_number = cls.get_highest_number(num_players)
        cards = []
        for color in CardColor.get_all_for_players(num_players):
            for value in range(1, highest_number + 1):
                cards.append(Card(value, color))
            cards.append(Card(0, color, is_queen=True))
        return cls(cards=cards)

    def contains_color(self, color: CardColor) -> bool:
        """Check if the stack contains a card of the given color."""
        return any(card.color == color for card in self.cards)

    def sort_cards(self) -> None:
        """Sort the cards in the stack."""
        self.cards.sort()

    def add_card(self, card: Card) -> None:
        """Add a card to the stack."""
        self.cards.append(card)

    def get_dealt_card_stacks(self, num_players: int) -> list["CardStack"]:
        """Deal out cards for each of the players."""
        random.shuffle(self.cards)
        hands = [CardStack() for _ in range(num_players + 1)]
        for _ in range(12):
            for hand in hands:
                hand.add_card(self.cards.pop())
        [hand.sort_cards() for hand in hands]
        return hands

    def get_trump(self) -> Card:
        """Determine the trump color based on the top card of the deck."""
        return self.cards.pop(random.randint(0, len(self.cards) - 1))

    def get_extra_cards(self) -> list[Card]:
        """Return the extra cards that are not dealt to the players."""
        return self.cards
