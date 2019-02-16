_do_plugin "repo"
_do_log_level_warn "proj"

declare -a _DO_PROJ_DIRS

function _do_proj_plugin() {
    local plugin=$1

    _do_log_debug "proj" "Register proj plugin $plugin"

    for cmd in "${_DO_REPO_COMMANDS[@]}"; do 
        local func="_do_${plugin}_repo_${cmd}"

        if _do_alias_exist "${func}"; then 
            _do_hook_after "_do_repo_${cmd}" "${func}"
        fi
    done
}


# Runs 'git add .' on the specified directory.
# Arguments: 
#   1.proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_proj_cmd() {
    local proj_dir=$1 
    shift

    _do_hook_call "_do_proj_cmd" $@ 
}

function _do_proj_default_exec_all_repo_cmds() {
    local cmd=$1

    local proj_dir=$(_do_proj_default_get_dir) 

    for repo in $( _do_proj_get_repo_list $proj_dir ); do 
        _do_alias_call_if_exists "${repo}-${cmd}"
    done    
}

# Gets all repositories in a proj.
#
function _do_proj_get_repo_list() {
    local dir=$1
    for name in $( ls -A $dir ); do 
        if [ -f "$dir/$name/.do.sh" ]; then 
            echo $name
        fi
    done
}


# Determines if a proj is loaded.
# $1. dir: string
#
function _do_proj_is_loaded() {
    local dir=$(_do_arg_required $1)
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
#
function _do_proj_init() {
    local dir=$(_do_arg_required $1)
    dir=$(_do_dir_normalized $dir)

    # Adds the current project to the directories
    _DO_PROJ_DIRS=( "${_DO_PROJ_DIRS}" "$dir" )

    _do_hook_call "_do_proj_init" "$dir" 

    # Initializes all sub directories as a code repository
    _do_log_debug "proj" "Adds proj directory $dir"
    for name in $( _do_proj_get_repo_list $dir ); do 
        if _do_repo_is_enabled $dir $name; then 
            _do_repo_init $dir $name
        fi
    done
}


# Gets the project directory of the current directory.
#
function _do_proj_default_get_dir() {

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
    _do_proj_init "$DO_HOME/.."
}
