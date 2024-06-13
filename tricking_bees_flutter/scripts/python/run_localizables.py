#!/bin/bash
"""Quick and dirty script to read the different .strings files and
merge them to single json files for each language"""
import logging

import helper_module as hm

logging.basicConfig(level="INFO")


if __name__ == "__main__":
    hm.merge_all_localizables()
