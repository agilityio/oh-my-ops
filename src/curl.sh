function _do_curl_wait_url() {
    local url=$1

    # Converts timeout to number
    local timeout=$(($2 + 0))

    local start_time=$(date +%s)

    local err=0
    until $(curl --output /dev/null --silent --head --max-time 5 $url); do

        local end_time=$(date +%s)
        if [ ! -z "$timeout" ] && [ $((end_time - start_time)) -gt $timeout ]; then 
            # Exceed timeout setting. 
            err=1
            break
        fi

        # Sleeps before trying again.
        sleep 5
    done
    
    return $err
}


function _do_curl_url_exist {
    local url=$1
    curl --output /dev/null --silent --head --max-time 1 --fail $url &> /dev/null
    
    local err=$?
    if _do_error $err; then 
        return 1
    else 
        return 0
    fi 
}

function _do_curl_assert {
    local url=$1
    _do_curl_url_exist $url || _do_assert_fail "Expect '$url' to be available"
}


function _do_curl_assert_not {
    local url=$1
    ! _do_curl_url_exist $url || _do_assert_fail "Expected '$url' to be unavailable."
}


