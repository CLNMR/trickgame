from dataclasses import dataclass
from enum import Enum


class CardColor(Enum):
    RED = "red"
    GREEN = "green"
    BLUE = "blue"
    YELLOW = "yellow"
    BLACK = "black"

    @staticmethod
    def get_color_num_for_player_num(num_players: int) -> int:
        return 3 if num_players == 2 else 4 if num_players in (3, 4) else 5

    @staticmethod
    def get_all_for_players(num_players: int) -> list["CardColor"]:
        num_colors = CardColor.get_color_num_for_player_num(num_players)
        return [color for color in CardColor][:num_colors]


@dataclass
class Card:
    value: int
    color: CardColor
    is_queen: bool = False

    def __str__(self) -> str:
        if self.is_queen:
            return f"{self.color.value} queen"
        return f"{self.color.value} {self.value}"

    def __repr__(self) -> str:
        return str(self)

    def __eq__(self, value: object) -> bool:
        if not isinstance(value, Card):
            return False
        return (
            self.is_queen == value.is_queen
            and self.value == value.value
            and self.color == value.color
        )

    def __lt__(self, other: "Card") -> bool:
        if self.color != other.color:
            return self.color.value < other.color.value
        if self.value != other.value:
            return self.value < other.value
        return not self.is_queen and other.is_queen
