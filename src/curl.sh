function _do_curl_wait_url() {
    local url=$1
    echo "Waits for $url to available"
    until $(curl --output /dev/null --silent --head --max-time 1 --fail $url); do
        sleep 5
    done
}
