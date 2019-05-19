_do_plugin "repo"

_do_log_level_warn "proj"

# The array of all project directories.
declare -a _DO_PROJ_DIRS

# The map from project to a default repository.
# The default repository would often be the git repository 
# that activate the do framework.
declare -A _DO_PROJ_REPO_MAP



function _do_proj_list() {
    echo ${_DO_PROJ_DIRS[@]}
}

# Executes a project level command. 
#
# Arguments: 
#   1. proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_proj_cmd() {
    local proj_dir=$1 
    shift

    _do_hook_call "_do_proj_cmd" $@ 
}

# Executes a repository level commands.
#
function _do_proj_default_exec_all_repo_cmds() {
    local cmd=$1
    shift 1

    local proj_dir=$(_do_proj_default_get_dir) 

    for repo in $( _do_proj_get_repo_list $proj_dir ); do 
        _do_alias_call_if_exists "${repo}-${cmd}" "$@"
    done    
}


# Gets all repositories in a proj.
#
function _do_proj_get_repo_list() {
    local dir=$1
    local name
    for name in $( ls -A $dir ); do 
        if [ -f "$dir/$name/.do.sh" ]; then 
            echo $name
        fi
    done
}


# Determines if a proj is loaded.
# Arguments:
#   1. dir: string
#
# Returns: 0 if the project is loaded. Otherwise 1.
#
function _do_proj_is_loaded() {
    local dir=${1?'dir arg required'}
    dir=$(_do_dir_normalized $dir)

    for i in "${_DO_PROJ_DIRS[@]}"; do 
        if [ "$i" = "$dir" ]; then 
            # Found the proj in the loaded list.
            return 0
        fi 
    done

    # Could not found in the loaded list.
    return 1
}


# Adds a project to devops management.
# Arguments:
#   1. dir: The absolute director to the project home.
#   2. def_repo_dir: Optional. The default repository discovered for this 
#       project. If it exists, it is possible to automatically set up 
#       git remote on a new repo clone or init.
#       
function _do_proj_init() {

    local dir=${1?'dir arg required'}
    local def_repo=$2

    dir=$(_do_dir_normalized $dir)

    if [ ! -z "${def_repo}" ]; then 
        # If the default repository is passed in. 
        _do_dir_assert "${dir}/${def_repo}"
    fi 

    # This is the default repository for the current repository.
    local proj_var=$(_do_string_to_uppercase_var $dir)
    _DO_PROJ_REPO_MAP[${proj_var}]="${def_repo}"

    # Initializes all sub directories as a code repository
    _do_log_debug "proj" "Adds proj directory $dir"

    # Adds the current project to the directories
    _DO_PROJ_DIRS=( ${_DO_PROJ_DIRS} "$dir" )

    _do_hook_call "_do_proj_init" "$dir" 

    local name
    for name in $( _do_proj_get_repo_list $dir ); do 
        if _do_repo_is_enabled $dir $name; then 
            _do_repo_init $dir $name
        fi
    done
}


# Gets the default repository name, given a project directory. 
# Arguments:
#   1. dir: The project directory.
#
function _do_proj_repo_get_default() {
    local dir=${1?'dir arg required'}
    _do_dir_assert ${dir}

    dir=$(_do_dir_normalized ${dir})
    local proj_var=$(_do_string_to_uppercase_var $dir)
    echo "${_DO_PROJ_REPO_MAP[${proj_var}]}"
}


# Gets the default repository name, given a project directory. 
# Arguments:
#   1. dir: The project directory.
#
function _do_proj_repo_set_default() {
    local dir=${1?'dir arg required'}
    _do_dir_assert ${dir}
    dir=$(_do_dir_normalized ${dir})

    local repo=${2?'repo arg required'}
    _do_dir_assert "$dir/$repo"

    local proj_var=$(_do_string_to_uppercase_var $dir)
    _DO_PROJ_REPO_MAP[${proj_var}]=$repo
}


# Gets the project directory of the current directory.
#
function _do_proj_default_get_dir() {

    if [ ${#_DO_PROJ_DIRS[@]} -eq 1 ]; then 
        # If just 1 proj dir is loaded, this is easy. 
        # Just returns that project directory
        echo ${_DO_PROJ_DIRS[0]}
        return
    fi 

    # From the current directory, keep traverse back work to find a project 
    # container loaded before.
    _do_dir_push $(pwd)

    while [ 1 ]; do 
        local dir=$(pwd)
        if [ "$dir" == '/' ]; then 
            echo ""
            _do_dir_pop
            return
        fi 

        dir=$(_do_dir_normalized $dir)
        if _do_proj_is_loaded $dir; then 
            # Found the project directory
            echo "$dir"
            _do_dir_pop
            return 
        fi

        cd ..
    done
}


# Initializes plugin.
#
function _do_proj_plugin_ready() {
    _do_log_info "proj" "Plugin ready"

    local last_index=${#BASH_SOURCE[@]}
    last_index=$((size - 1))
    
    local file=${BASH_SOURCE[$last_index]}
    _do_log_debug "proj" "last file in bash source $file"

    local dir="$(dirname $file)"
    _do_log_debug "proj" "last dir in bash source $dir"

    _do_dir_push $dir 

    local def_repo_dir=$(git rev-parse --show-toplevel 2> /dev/null)
    _do_log_debug "proj" "git root dir $def_repo_dir"
    
    if [ -z "$def_repo_dir" ]; then 
        dir=.
    else 
        dir=$def_repo_dir/..
        def_repo_dir=$(basename $def_repo_dir)
    fi

    dir=$(_do_dir_normalized $dir)

    _do_dir_pop

    _do_log_debug "proj" "Loading projects at $dir, with default: '${def_repo_dir}'"

    _do_proj_init "${dir}" "${def_repo_dir}"
}
