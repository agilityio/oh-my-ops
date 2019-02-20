

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
    if [ "$DO_OS" = "cygwin" ] || [ "$DO_OS" = "mingw" ]; then
        return 0
    else
        return 1
    fi
}
