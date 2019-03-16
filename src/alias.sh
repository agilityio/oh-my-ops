# This function checks if an alias or type exists
# Return: "yes" if exists; otherwise, return "no"
#
# Arguments:
#   ...name
function _do_alias_exist() {
    : ${1?'Alias name is required'}

    while (( $# > 0 )); do
        local name=$1
        shift 1

        if (alias "${name}" &>/dev/null || type "${name}" &>/dev/null); then
            continue
        else
            # The current alias does not exist
            return 1
        fi
    done

    return 0
}

function _do_alias_call_if_exists() {
    local name=$1
    
    if _do_alias_exist $name; then 
        eval "$@"
    fi
}

# Gets the list of alias given a prefix.
function _do_alias_list() {
    local prefix=$1
    alias | grep "alias ${prefix}" | sed -e "s/alias[[:blank:]]*${prefix}\([[:alnum:]_-]*\)=.*$/\1/"
}


function _do_alias_feature_check() {
    local feature=${1?'Support name required'}
    shift 1

    : ${1?'Alias name is required'}

    local miss=()

    while (( $# > 0 )); do
        local name=$1
        shift 1

        if (alias "${name}" &>/dev/null || type "${name}" &>/dev/null); then
            continue
        else
            # This alias is missing
            miss+=( "${name}" )
        fi
    done

    if (( ${#miss[@]} > 0 )); then 
        _do_log_warn "${feature}" "Disable ${feature} supports because of missing ${miss[@]} commands"
        return 1
        
    else 
        return 0
    fi 
}
