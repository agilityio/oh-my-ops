
function _do_repo_dir_array_new() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    local name=${3?'name arg required'}
    
    local pattern=${4?'pattern arg required'}
    local excluded_dirs=${5:-}

    _do_dir_push "${proj_dir}/${repo}"

    local opts=""
    if [ ! -z "${excluded_dirs}" ]; then 
        opts="! -path ${excluded_dirs}"
    fi

    local arr=()
    local dir
    for dir in $(find . -type f -name "${pattern}" ! -path '.git/*' ! -path '*/node_modules/*' ${opts} -print); do 
        arr+=( "$(dirname ${dir})" )
    done

    _do_array_new "_rd_${repo}_${name}" ${arr[@]}

    _do_dir_pop
}

function _do_repo_dir_array_exists() {
    local repo=${1?'repo arg required'}
    local name=${2?'name arg required'}

    if _do_array_exists "_rd_${repo}_${name}"; then 
        return 0
    else 
        return 1
    fi
}

function _do_repo_dir_array_is_empty() {
    local repo=${1?'repo arg required'}
    local name=${2?'name arg required'}

    if _do_array_is_empty "_rd_${repo}_${name}"; then 
        return 0
    else 
        return 1
    fi
}


function _do_repo_dir_array_print() {
    local repo=${1?'repo arg required'}
    local name=${2?'name arg required'}
    _do_array_print "_rd_${repo}_${name}" 
}


function _do_repo_dir_array_destroy() {
    local repo=${1?'repo arg required'}
    local name=${2?'name arg required'}
    _do_array_destroy "_rd_${repo}_${name}" 
}
