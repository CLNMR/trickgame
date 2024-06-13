"""Constants used throughout the module."""
import json
from pathlib import Path

# The path where the full tricking_bees data stuff is in.
BASE_PATH = Path(__file__).parent.parent.parent.parent

# Here we store the assets.
ASSET_PATH = BASE_PATH.joinpath("packages/tricking_bees/assets")


def _load_localizable_prefixes() -> dict[str, str]:
    with ASSET_PATH.joinpath("localizables/prefix_registry.json").open(
        "r", encoding="utf-8"
    ) as f:
        return json.load(f)


# The mapping between directory names and localizable prefixes
LOC_PREFIX_MAPPING = _load_localizable_prefixes()
