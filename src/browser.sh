# Utility function for quickly open a browser url.
# Arguments:
#   1. url: The url to open.
#
function _do_browser_open() {
    local url=$1

    if [ "${DO_OS}" =  "mac" ]; then
        # For mac, the open command is supported by default.
        open "${url}"

    elif which xdg-open > /dev/null; then
        xdg-open "${url}"

    elif which gnome-open > /dev/null; then
        gnome-open "${url}"

    else
        echo "Cannot open ${url}"
    fi
}


# Utility function for quickly open a browser url in async mode.
# This function will used curl to wait for the url to be available
# before actually open it
# Arguments:
#   1. url: The url to open.
#
function _do_browser_open_async() {
    local url=$1

    printf "Openning ${url}"
    until $(curl --output /dev/null --silent --head --max-time 1 --fail $url); do
        sleep 1
        printf "."
    done && echo "open ${url}" && _do_browser_open "${url}" &
    echo $!
}
