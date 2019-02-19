function test_curl() {
    _do_curl_assert "https://google.com"
    _do_curl_assert_not "no-url"
}
    
function test_curl_wait() {
    _do_curl_wait_url "https://google.com" 10 || _do_assert_fail
    ! _do_curl_wait_url "no-url" 10 || _do_assert_fail
}
