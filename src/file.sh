function _do_file_name() {
    local name="$1"
    echo "${name##*/}"   
}

function _do_file_name_without_ext() {
    local name="$(_do_file_name $1)"
    echo "${name%%.*}"   
}

function _do_file_ext() {
    local name="$1"
    echo "${name#*.}"   
}
