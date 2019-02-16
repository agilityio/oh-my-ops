#!/usr/bin/env bash

# Uncommand this to just load the specified plugins
# DO_PLUGINS="proj git"

DO_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

# Activates the main source file.
source "$DO_HOME/src/main.sh"
