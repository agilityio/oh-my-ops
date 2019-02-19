function test_curl() {
    _do_curl_assert "https://google.com"
    _do_curl_assert_not "no-url"
}
