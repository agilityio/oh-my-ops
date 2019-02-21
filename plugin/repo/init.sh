_do_log_level_warn "repo"

_do_src_include_others_same_dir

# This function looks are a directory and if there is a file named ".do.sh" then
# devops is enabled for that repository. 
# 
function _do_repo_is_enabled() {
    local proj_dir=$1
    local repo=$2    
    if [ -f "$proj_dir/$repo/.do.sh" ]; then 
        return 0
    else 
        return 1
    fi
}


# Change directory and push it to stack.
#
function _do_repo_dir_push() {
    local proj_dir=$1
    local repo=$2

    pushd "$proj_dir/$repo" &> /dev/null
}


# Registers plugin specific repo commands. 
# Arguments:
#   1. proj_dir: The project absolute directory.
#   2. repo: The repo name.
#   3. plugin: The plugin name.
#   4. The global array name that contains all plugin commands.
#
# Notes:
#   odd syntax here for passing array parameters: 
#   http://stackoverflow.com/questions/8082947/how-to-pass-an-array-to-a-bash-function
#
function _do_repo_plugin() {
    local proj_dir=$1
    local repo=$2
    local plugin=$3
    local cmds=$4[@]


    for cmd in "${!cmds}"; do 
        # Converts the command to undercase
        local under_cmd=$(_do_string_to_undercase $cmd)
        local func="_do_${plugin}_repo_${under_cmd}"

        local cmd="${repo}-${plugin}-${cmd}"

        if ! _do_alias_exist "${cmd}"; then 
            # Register an alias for the plugin repo command.
            _do_log_debug "repo" "Register '${cmd}' alias"

            alias "${cmd}"="${func} ${proj_dir} ${repo}"
        fi
    done
}


# Runs 'git add .' on the specified directory.
# Arguments: 
#   1.proj_dir: The project home directory.
#   2. repo: The repository name.
#
function _do_repo_cmd() {
    local proj_dir=$1 
    shift
    local repo=$1
    shift

    _do_print_header_2 "$repo: $@"
    _do_repo_dir_push $proj_dir $repo 

    eval $@
    local err=$?

    _do_dir_pop
    return $err
}



# Initializes plugin.
function _do_repo_plugin_init() {
    _do_log_info "repo" "Plugin initialize"

    alias "do-repo-gen"="_do_repo_gen"
    _do_hook_after "_do_prompt" "_do_repo_prompt_changed"
}
