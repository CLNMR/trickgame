from dataclasses import dataclass, field

from .card import Card, CardColor
from .card_stack import CardStack
from .role import Role


@dataclass
class Player:
    name: str
    tricks_won: int = 0
    hand: CardStack = field(init=False)
    current_role: Role = field(default_factory=Role)
    total_points: int = 0

    def __post_init__(self):
        self.hand = CardStack()

    def reset_for_new_subgame(self):
        """Resets the player for a new subgame."""
        self.tricks_won = 0
        self.hand = CardStack()
        self.current_role = Role()

    def deal_hand(self, card_stack: CardStack):
        """Deal a hand to the player."""
        self.hand = card_stack

    def try_play_card(
        self,
        card: Card,
        compulsory_color: CardColor | None = None,
    ) -> bool:
        """Try to play a card from the player's hand."""
        if card not in self.hand.cards:
            return False
        if compulsory_color is not None and self.hand.contains_color(compulsory_color):
            if card.color != compulsory_color:
                return False
        self.hand.cards.remove(card)
        return True

    def get_playable_cards(
        self, has_turn: bool = False, compulsory_color: CardColor | None = None
    ) -> list[Card]:
        """Return the cards the player can currently play."""
        if not has_turn:
            return []
        return self.current_role.get_playable_cards(self.hand, compulsory_color)
