#!/bin/bash
cd "${0%/*}"

# Restore snips.toml from backup if necessary
./config_cp.sh

# Init SAM
./sam_init.sh
