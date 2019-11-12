#!/usr/bin/env bash

set -e

# The directory where this script is executed.
CUR_DIR="$(pwd)"

# The repository name.
DO_REPO="do"

# The home directory from do framework.
INSTALL_DIR="${CUR_DIR}/${DO_REPO}"

echo "Initializes empty ${DO_REPO}"
mkdir ${DO_REPO}
cd ${DO_REPO}

echo "Add oh-my-ops as git sub module"
git init

echo "* text=auto
*.sh text eol=lf" > .gitattributes

echo "Pull oh-my-ops framework"

mkdir vendor
cd vendor

# Initializes devops as the submodule of the current repository
git submodule add https://github.com/trungngo/oh-my-ops.git

# Pull the submodule
git submodule init

# Generates additional files.
cd ${INSTALL_DIR}

src_files=(
    "version"
    "os"
    "src"
    "color"
    "print"
    "assert"
    "arg"
)

# Loads all core source files.
for src_file in "${src_files[@]}"; do
    source "vendor/oh-my-ops/src/${src_file}.sh"
done


echo '
DO
==

## Get Starts

Runs the following command to activate the `do` virtual environment.

```
bash
source activate.sh
```

## Prerequisites

* Bash 4+ 
* Git, Curl
* Docker
* MacOSX, Linux, or Windows (Cygwin)

* Optional:
    * Python
    * NodeJS
    * Go
    * Typescript
    * Dotnet
    * Java
    * Vagrant

' > "README.md"


echo 'function _do_do_repo_plugin_ready() {
    _do_log_level_debug "do"
    _do_log_info "do" "do repo is ready"
}


# Updates submodules like oh-my-ops framework
#
function do-update() {
    _do_print_header_2 "Update dependencies"

    _do_dir_push $(_do_src_dir)
    git submodule update --recursive
    _do_dir_pop
}
' > ".do.sh"


# Generates the 
echo '# The array of plugin name to be included. If this variable is not specified
# all plugins found will be included by default.
# DO_PLUGINS="proj git prompt"

# The array of plugin name to be excluded. This list have higher priority
# than the above plugins list.
# DO_PLUGINS_EXCLUDED=slack


# Updates submodules like oh-my-ops framework
#
function do-update() {
    _do_print_header_2 "Update dependencies"

    eval do-cd

    git submodule update --recursive
}


source vendor/oh-my-ops/activate.sh $@
' > "activate.sh"


# Generates the src directory where custom plugins can be put here.
mkdir src
touch src/.keep

git add .

_do_print_banner "\n
        Do ${DO_VERSION} installed at: ${CUR_DIR}/${DO_REPO}.
        Runs 'source ./activate.sh' in bash shell to start and 
        then run 'do-help' for more information."

