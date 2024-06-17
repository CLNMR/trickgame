from dataclasses import dataclass
from math import ceil
from typing import TYPE_CHECKING, override

if TYPE_CHECKING:
    from .card import Card, CardColor
    from .card_stack import CardStack
    from .player import Player


@dataclass
class Role:
    letter: str = ""
    """The letter identifying the role."""
    name: str = ""
    """The name we give this role."""
    desc_benefits: str = ""
    """Description of benefits the role offers."""
    desc_points: str = "2 x N_tricks"
    """Description of how this role scores points."""

    def calculate_points(self, tricks_won: int) -> int:
        """Calculate the points for this role."""
        return tricks_won * 2

    def get_playable_cards(
        self, hand: "CardStack", compulsory_color: "CardColor | None"
    ) -> list["Card"]:
        """Tell a player with this role which cards they should be able to play."""
        if compulsory_color is None:
            return hand.cards
        if hand.contains_color(compulsory_color):
            return [card for card in hand.cards if card.color == compulsory_color]
        return hand.cards


class RoleA(Role):
    def __init__(self):
        self.letter = "A"
        self.name = "Skip-king"
        self.desc_benefits = "You don't have to play if you don't want to."


class RoleB(Role):
    def __init__(self):
        self.letter = "B"
        self.name = "Agony of choice"
        self.desc_benefits = (
            "In the beginning of the game, you may change the trump color."
        )


class RoleC(Role):
    def __init__(self):
        self.letter = "C"
        self.name = "Smart adaptation"
        self.desc_benefits = "In the beginning of the game, you may look through the remaining cards and exchange 2 with cards from your hand."


class RoleD(Role):
    def __init__(self):
        self.letter = "D"
        self.name = "Intermezzo"
        self.desc_benefits = (
            "You can decide to play your card earlier than you ought to."
        )


class RoleE(Role):
    def __init__(self):
        self.letter = "E"
        self.name = "The gray one"
        self.desc_benefits = "You may always play any of your cards, i.e. don't have to follow the compulsory color."
        self.desc_points = "N_tricks"

    @override
    def calculate_points(self, tricks_won: int) -> int:
        return tricks_won

    @override
    def get_playable_cards(
        self, hand: "CardStack", compulsory_color: "CardColor | None"
    ) -> list["Card"]:
        return hand.cards


class RoleF(Role):
    def __init__(self):
        self.letter = "F"
        self.name = "Double agent"
        self.desc_benefits = "In the beginning of the game, you receive 12 more cards and have to play two for each trick when you would usually only play one."
        self.desc_points = "N_tricks"

    @override
    def calculate_points(self, tricks_won: int) -> int:
        return tricks_won


class RoleG(Role):
    def __init__(self):
        self.letter = "G"
        self.name = "First in line"
        self.desc_benefits = "You begin every trick."
        self.desc_points = "N_tricks"

    @override
    def calculate_points(self, tricks_won: int) -> int:
        return tricks_won


class RoleH(Role):
    def __init__(self):
        self.letter = "H"
        self.name = "Copycat"
        self.desc_benefits = "In the beginning of the game, you choose two players whom you'll try to push."
        self.desc_points = "ceil((N_tricks^1 + N_tricks^2)/2)"

    def select_players(self, player_1: "Player", player_2: "Player"):
        """Select the players of whom the points are taken."""
        self.p1 = player_1
        self.p2 = player_2

    @override
    def calculate_points(self, tricks_won: int) -> int:
        if not hasattr(self, "p1") or not hasattr(self, "p2"):
            raise ValueError("Players have not been selected for this role.")
        # TODO: This is currently wrong, the player's points need to be calculated directly as they've won their own amount of tricks.
        p1_points = self.p1.current_role.calculate_points(tricks_won)
        p2_points = self.p2.current_role.calculate_points(tricks_won)
        return ceil((p1_points + p2_points) / 2)


class RoleI(Role):
    def __init__(self):
        self.letter = "I"
        self.name = "No trump"
        self.desc_benefits = "None of your cards are trumps."
        self.desc_points = "max(0, 8-N_tricks*2)"

    @override
    def calculate_points(self, tricks_won: int) -> int:
        return max(0, 8 - tricks_won * 2)


# Registry of available roles
ROLE_REGISTRY = {
    "RoleA": RoleA,
    "RoleB": RoleB,
}
