#!/usr/bin/env bash

set -e

# The directory where this script is executed.
REPO_DIR="$(pwd)"

mkdir do
cd do

mkdir src

# Generates the
# shellcheck disable=SC2016
echo '
# The array of plugins to enabled.
DO_PLUGINS="proj git prompt banner env full"

# The environments supported.
DO_ENVS="local dev stag prod"

# Uncomment this if you want to run with a specific version.
# DO_VERSION="0.1-alpha"

cd do
source "src/init.sh"

_do_proj ".." "proj"
_do_full_proj "proj"

# Enables git command at the project root.
_do_git "proj"
_do_banner
cd ..

' > "activate.sh"

# shellcheck disable=SC2016
echo '
function _do_init() {
  local repo="agilityio/oh-my-ops"

  if [ -z "${DO_VERSION}" ]; then
    DO_VERSION=$(curl --silent "https://api.github.com/repos/${repo}/releases/latest" | grep -Po '\''"tag_name": "v\K.*?(?=")'\'')
  fi

  [ -d ".oh-my-ops" ] || {
    echo "Download op-my-ops ${DO_VERSION} release."
    wget https://github.com/${repo}/archive/v${DO_VERSION}.zip &&
    unzip v${DO_VERSION}.zip &> /dev/null &&
    mv oh-my-ops-${DO_VERSION} .oh-my-ops &> /dev/null &&
    rm v${DO_VERSION}.zip &> /dev/null
  } || {
    echo "Cannot download oh-my-ops runtime."
    return 1
  }
}

function do-update() {
  [ ! -d ".oh-my-ops" ] || {
    echo "Remove old .oh-my-ops runtime."
    rm -rfd .oh-my-ops &> /dev/null &&
    _do_init &&
    _do_print_warn "Please exit and run source activate.sh again."
  } || {
    _do_print_error "Fail to upgrade."
  }
}

_do_init
source .oh-my-ops/activate.sh $@

' > 'src/init.sh'

echo "Runs 'source do/activate.sh' in bash shell to start."
