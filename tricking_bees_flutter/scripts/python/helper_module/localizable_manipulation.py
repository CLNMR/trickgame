"""Functions to read and manipulate localizable files."""

import json
import logging

from .constants import ASSET_PATH
from .file_io import get_yaml_dict, write_yaml_dict
from .util import compare_two_dicts, log_empty_keys


def _get_full_localizable_dict_for_language(
    lang="de", rewrite_merged=False
) -> dict[str, str]:
    """Merges all available strings files for a given language, adding the
    prefixes to each of the keys."""
    base_path = ASSET_PATH.joinpath(f"localizables/{lang}")
    full_dict = {}
    for fpath in base_path.iterdir():
        full_dict = full_dict | get_yaml_dict(fpath, lang, add_prefix=True)
    if not rewrite_merged:
        return full_dict
    json_name = "de-DE" if lang == "de" else "en-US"
    fpath = base_path.parent.joinpath(f"{json_name}.json")
    with open(fpath, "w", encoding="utf-8") as f:
        json.dump(full_dict, f, sort_keys=True, ensure_ascii=False, indent=2)
    return full_dict


def _update_localizables(lang1: str, lang2: str):
    """Puts the keys of the lang1 files in the lang2 ones and vice versa."""
    lang1path = ASSET_PATH.joinpath(f"localizables/{lang1}")
    lang2path = ASSET_PATH.joinpath(f"localizables/{lang2}")
    for fpath1 in lang1path.iterdir():
        fpath2 = lang2path.joinpath(fpath1.name)
        dict1 = get_yaml_dict(fpath1)
        dict2 = get_yaml_dict(fpath2)
        name1 = f"{lang1} {fpath1.name}"
        name2 = f"{lang2} {fpath2.name}"
        missing_keys = compare_two_dicts(dict1, dict2, name1, name2, remove_empty=True)
        new_content = dict2 | {key: "" for key in missing_keys}
        write_yaml_dict(fpath2, new_content, overwrite=True)


def merge_all_localizables():
    """Merges all available localizable files and dumps them in the json."""
    _update_localizables("de", "en")
    _update_localizables("en", "de")
    de_dict = _get_full_localizable_dict_for_language("de", rewrite_merged=True)
    en_dict = _get_full_localizable_dict_for_language("en", rewrite_merged=True)
    logging.info("Successfully rewrote the language files.")
    compare_two_dicts(de_dict, en_dict, "German", "English")
    compare_two_dicts(en_dict, de_dict, "English", "German")
    log_empty_keys(de_dict, "German")
    log_empty_keys(en_dict, "English")
