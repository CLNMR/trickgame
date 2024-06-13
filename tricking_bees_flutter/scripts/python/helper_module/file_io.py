"""Utility functions for reading and writing files."""

import logging
from pathlib import Path

import yaml
from yaml.parser import ParserError
from yaml.scanner import ScannerError

from .constants import LOC_PREFIX_MAPPING


def get_yaml_dict(fpath: Path, lang="de", add_prefix=False) -> dict[str, str]:
    """Read the dictionary in the given yaml file, enriching it with the prefix
    corresponding to the filename if desired."""
    with fpath.open("r", encoding="utf-8") as f:
        try:
            content = yaml.safe_load(f)
        except ParserError as exc:
            msg = f"Couldn't parse {fpath.name} ({lang}): {exc}.\n\n."
            msg += "Is there any line starting with a { character, or a ' in it? Such strings should be enclosed in quotes."
            raise ValueError(msg)
        except ScannerError as exc:
            msg = f"Couldn't parse {fpath.name} ({lang}): {exc}.\n\n."
            msg += "Is there any line where you have a colon : not enclosed in quotes?"
            raise ValueError(msg)
    if not isinstance(content, dict):
        warn_msg = f"Couldn't properly read {fpath.name} ({lang}), ignoring it for now."
        logging.warning(warn_msg)
        return {}
    if add_prefix:
        fname = fpath.with_suffix("").name
        assert fname in LOC_PREFIX_MAPPING, f"{fname} hasn't been mapped to a prefix"
        prefix = LOC_PREFIX_MAPPING[fname]
        # Empty strings shouldn't be prefixed with a colon:
        content = {
            (f"{prefix}:{key}" if prefix != "" else key): val
            for key, val in content.items()
        }
    return content


def write_yaml_dict(fpath: Path, yaml_dict: dict, overwrite=False):
    """Writes the given dictionary to a yaml file."""
    if not overwrite and fpath.exists():
        msg = f"Skipped writing {fpath} as it already existed."
        logging.warning(msg)
    with fpath.open("w", encoding="utf-8") as f:
        yaml.safe_dump(yaml_dict, f, encoding="utf-8", allow_unicode=True)
