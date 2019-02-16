# This function checks if an alias or type exists
# Return: "yes" if exists; otherwise, return "no"
function _do_alias_exist() {
    local alias_name=$1
    if (alias "$alias_name" &>/dev/null || type "$alias_name" &>/dev/null); then
        return 0
    else
        return 1
    fi
}

function _do_alias_call_if_exists() {
    local name=$1
    if _do_alias_exist $name; then 
        eval $name
    fi
}

# Gets the list of alias given a prefix.
function _do_alias_list() {
    local prefix=$1
    alias | grep "alias ${prefix}" | sed -e "s/alias[[:blank:]]*${prefix}\([[:alnum:]_-]*\)=.*$/\1/"
}
