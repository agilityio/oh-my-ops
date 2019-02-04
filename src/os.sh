# Figures out which operating system we are on.
DO_OS=""

if [ "$(uname)" = "Darwin" ]; then
    # Do something under Mac DO_OS X platform
    DO_OS="mac"
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    # Do something under Linux platform
    DO_OS="linux"
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then
    DO_OS="win"
elif [ "$(expr substr $(uname -s) 1 6)" = "CYGWIN" ]; then
    DO_OS="win"
fi


# Determines if the current OS is Mac
#
function _do_os_is_mac() {
    if [ "$DO_OS" = "mac" ]; then
        return 0
    else
        return 1
    fi
}


# Determines if the current OS is Linux
function _do_os_is_linux() {
    if [ "$DO_OS" = "linux" ]; then
        return 0
    else
        return 1
    fi
}


# Determines if the current OS is Windows
#
function _do_os_is_win() {
    if [ "$DO_OS" = "win" ]; then
        return 0
    else
        return 1
    fi
}

