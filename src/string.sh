# See: https://www.gnu.org/software/gawk/manual/html_node/String-Functions.html
#
 
function _do_string_to_upper() {
    local str="${1}"
    echo $str | awk '{print toupper($0)}'
}

function _do_string_to_lower() {
    local str="${1}"
    echo $str | awk '{print tolower($0)}'
}

function _do_string_to_undercase() {
    local str="${1}"
    echo $str | sed -e 's/[[:blank:]]/_/g' -e 's/-/_/g'
}

function _do_string_to_dash() {
    local str="${1}"
    echo $str | sed -e 's/[[:blank:]]/_/g' -e 's/[_\.]/-/g'
}

function _do_string_to_env_var() {
    local str="$1"
    str="${str//\//-}"
    str=$(_do_string_to_upper $str)
    str=$(_do_string_to_undercase $str)
    echo "$str"
}

function _do_string_urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

function _do_string_urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}
