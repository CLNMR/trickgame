"""A class keeping track of the current game state."""

from dataclasses import dataclass, field

from .card import Card, CardColor
from .card_stack import CardStack
from .player import Player


@dataclass
class Game:
    """A class keeping track of the current game state."""

    players: list["Player"]
    """The players in the game."""

    subgame_index: int = 0

    current_round: int = 1
    """The current round number."""
    current_player_index: int = 0
    """The index of the player whose turn it is."""
    current_trump: Card | None = None
    """The trump of the current round."""
    current_trick: list["Card"] = field(default_factory=list)
    """The cards played in the current trick."""
    remaining_deck: CardStack = field(default_factory=CardStack)
    """The remaining cards."""

    log: str = ""
    """A log of the game's events."""

    @classmethod
    def from_player_names(cls, player_names: list[str]) -> "Game":
        """Create a new game with the given player names."""
        return cls(players=[Player(name) for name in player_names])

    @property
    def num_players(self) -> int:
        return len(self.players)

    @property
    def current_player(self) -> "Player":
        return self.players[self.current_player_index]

    @property
    def current_trump_color(self) -> CardColor | None:
        return None if self.current_trump is None else self.current_trump.color

    @property
    def status_message(self) -> str:
        """Return a message describing the current game state."""
        text = f"Subgame {self.subgame_index + 1}, round {self.current_round}.\n"
        if self.current_trump is None:
            return text + "Waiting for the trump to be chosen"
        text += f"Trump is {self.current_trump}.\n"
        text += f"Waiting for {self.current_player.name} to play"
        if self.compulsory_color is not None:
            text += f" ({self.compulsory_color.value} is compulsory)"
        return text + "."

    @property
    def compulsory_color(self) -> CardColor | None:
        return None if len(self.current_trick) == 0 else self.current_trick[0].color

    def add_log_msg(self, msg: str):
        self.log += msg + "\n"
        print(msg)

    def start_new_subgame(self):
        """Start a new subgame."""
        self.subgame_index += 1
        self.current_round = 1
        self.current_player_index = 0
        self.current_trump = None
        self.remaining_deck = CardStack.from_initial_deck(self.num_players)
        card_stacks = self.remaining_deck.get_dealt_card_stacks(self.num_players)
        for player in self.players:
            player.reset_for_new_subgame()
            player.deal_hand(card_stacks.pop())

        self.current_trump = self.remaining_deck.get_trump()
        self.add_log_msg(f"Subgame {self.subgame_index} started.")
        self.add_log_msg(f"Trump is {self.current_trump}.")

    def start_new_round(self):
        """Start a new round."""
        self.current_trick = []

    def try_play_card(self, card: Card) -> bool:
        """Try to play a card."""
        if not self.current_player.try_play_card(card, self.compulsory_color):
            return False
        self.current_trick.append(card)
        card_desc = str(card)
        if card.color == self.current_trump_color and not card.is_queen:
            card_desc += " [trump]"
        self.add_log_msg(f"    {self.current_player.name} played {card_desc}.")
        self.go_to_next_player()
        return True

    def go_to_next_player(self):
        """Go to the next player."""
        if len(self.current_trick) == self.num_players:
            self.evaluate_trick()
            self.start_new_round()
            return
        self.current_player_index = (self.current_player_index + 1) % self.num_players

    def evaluate_trick(self):
        """Evaluate the trick and update the game state."""
        # Find the winning card:
        # If the trick contains a queen, the winning card is the last queen.
        # If otherwise the trick contains the trump, the winning card is the highest trump.
        # Otherwise the highest card of the compulsory color wins.
        if any(card.is_queen for card in self.current_trick):
            winning_card = next(
                card for card in reversed(self.current_trick) if card.is_queen
            )
        elif any(card.color == self.current_trump_color for card in self.current_trick):
            winning_card = max(
                (
                    card
                    for card in self.current_trick
                    if card.color == self.current_trump_color
                )
            )
        else:
            winning_card = max(
                (
                    card
                    for card in self.current_trick
                    if card.color == self.compulsory_color
                )
            )
        winning_player_index = (
            self.current_player_index + 1 + self.current_trick.index(winning_card)
        ) % self.num_players
        winner = self.players[winning_player_index]
        winner.tricks_won += 1
        self.current_player_index = winning_player_index
        self.add_log_msg(f"--> {winner.name} wins the trick with the '{winning_card}'.")
