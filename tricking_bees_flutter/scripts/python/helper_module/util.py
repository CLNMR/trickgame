"""Utility functions."""

import logging


def compare_two_dicts(
    dict1: dict, dict2: dict, desc1: str, desc2: str, remove_empty=True, verbose=True
) -> set[str]:
    """Retrieves the difference in keys for the dicts, i.e. which keys are
    present in dict1, but not in dict2.
    """
    missing_keys = set(dict1).difference(dict2)
    if remove_empty:
        missing_keys = {key for key in missing_keys if dict1[key] != ""}
    if not verbose:
        return missing_keys
    if len(missing_keys) == 0:
        text = f"All keys of the {desc1} file are also available in {desc2}. Nice!"
    else:
        text = (
            f"The following keys are present in the {desc1}, but not "
            f"in the {desc2} file:\n\t{missing_keys}"
        )
    logging.info(text)
    return missing_keys


def log_empty_keys(lang_dict: dict, desc: str):
    """Log the keys of the dictionary that contain an empty string"""
    empty_keys = [key for key, val in lang_dict.items() if val == ""]
    if len(empty_keys) == 0:
        return
    text = (
        f"The following keys of the {desc} file contain empty values:\n\t{empty_keys}"
    )
    logging.info(text)


def get_unique_substrings(full_strings: list[str]) -> list[str]:
    """Get the most matching beginnings of the strings.

    Example
    -------
    >>> get_unique_substrings(["Alan", "Alastair", "Henry", "Holger", "Johannes"])
    ['Alan', 'Alas', 'He', 'Ho', 'J']

    Parameters
    ----------
    full_strings : list[str]
        A list of strings to shorten to the most unique substrings

    Returns
    -------
    list[str]
        A list of the most unique substrings of the input strings.
    """
    shortened = []
    for name in full_strings:
        for i in range(len(name)):
            my_slice = slice(0, i + 1)
            substring = name[my_slice]
            other_substrings = [
                n[my_slice] for n in full_strings if n != name and (len(n) > (i + 1))
            ]
            if substring not in other_substrings:
                shortened.append(substring)
                break
    return shortened


if __name__ == "__main__":
    # Test whether the code works as intended prior to the dart implementation.
    test = ["Alan", "Alastair", "Henry", "Holger", "Johannes", "Klaus", "M"]
    get_unique_substrings(test)
