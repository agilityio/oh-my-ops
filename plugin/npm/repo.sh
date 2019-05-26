_DO_NPM_REPO_CMDS="help clean build"
_DO_NPM_PATHS=()


# Displays helps about how to run a repository npm commands.
#
function _do_npm_repo_help() {
    local proj_dir=$1
    local repo=$2
    
    if ! _do_npm_repo_enabled $proj_dir $repo; then 
        return
    fi 

    _do_print_header_2 "$repo: npm help"

    echo "  
  ${repo}-npm-help: 
    See npm command helps

  ${repo}-npm-clean: 
    Cleans npm build output

  ${repo}-npm-build: 
    Runs 'npm install'

  ${repo}-npm-status: 
    Displays the npm status."

    local name
    for name in $(_do_repo_dir_array_print "${repo}" "npm"); do
        if [ "$name" != '.' ]; then 
            # Removes the main.npm out of the command name.
            local cmd=$(_do_string_to_alias_name ${name})
            echo "  
  ${repo}-npm-clean-${cmd}:
    Runs npm clean on $name

  ${repo}-npm-build-${cmd}:
    Runs npm build on $name

  ${repo}-npm-test-${cmd}:
    Runs npm test on $name"
        fi
    done
}

# Cleans the repository npm output.
#
function _do_npm_repo_clean() {
    local proj_dir=$1
    local repo=$2

    if ! _do_npm_repo_enabled $proj_dir $repo; then 
        return
    fi 

    for dir in $(_do_repo_dir_array_print "${repo}" "npm"); do
        _do_npm_repo_proj_cmd \"${proj_dir}\" \"${repo}\" \"${dir}\" npm install
    done

    local err=$?
    _do_error_report $err "$title"
    return $err
}


# Builds the npm repository.
#
function _do_npm_repo_build() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    if ! _do_npm_repo_enabled "${proj_dir}" "${repo}"; then 
        return
    fi 

    local err=0
    local dir
    for dir in $(_do_repo_dir_array_print "${repo}" "npm"); do
        _do_npm_repo_proj_cmd \"${proj_dir}\" \"${repo}\" \"${dir}\" npm install || err=1
    done

    _do_error_report $err "$title"
    return $err
}

# Test the npm repository.
#
function _do_npm_repo_test() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    if ! _do_npm_repo_enabled "${proj_dir}" "${repo}"; then 
        return
    fi 

    local err=0
    local dir
    for dir in $(_do_repo_dir_array_print "${repo}" "npm"); do
        _do_npm_repo_proj_cmd \"${proj_dir}\" \"${repo}\" \"${dir}\" npm run test || err=1
    done

    _do_error_report $err "$title"
    return $err
}


# Determines if the specified directory has npm enabled.
# Arguments:
#   1. dir: A directory.
# 
# Returns: 
#   0 if npm enabled, 1 otherwise.
#
function _do_npm_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if _do_repo_dir_array_is_empty "${repo}" "npm"; then 
        return 1
    else 
        return 0
    fi 
}

function _do_npm_repo_uninit() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    # Removes all unalias
    _do_alias_remove_by_prefix "${repo}-npm"
    _do_repo_cmd_hook_remove "${repo}" "npm" "${_DO_NPM_REPO_CMDS}"

    # Just keeps init alias so that it can be reinitialized
    _do_repo_alias_add ${proj_dir} ${repo} "npm" "init"

    # Destroy the array that keep npm projects
    if _do_repo_dir_array_exists "${repo}" "npm"; then 
        _do_repo_dir_array_destroy "${repo}" "npm"
    fi
}


# Initializes npm support for a repository.
#
function _do_npm_repo_init() {
    local proj_dir=${1?'proj_dir argument required'}
    local repo=${2?'repo argument required'}

    _do_npm_repo_uninit "${proj_dir}" "${repo}"

    _do_repo_dir_array_new "${proj_dir}" "${repo}" "npm" "package.json"

    if ! _do_npm_repo_enabled ${proj_dir} ${repo}; then 
        # Adds alias for generating npm project.
        _do_repo_alias_add $proj_dir $repo "npm" "gen"
        
        _do_log_debug "npm" "Skips npm support for '$repo'"
        # This directory does not have npm support.
        return
    fi 

    # Sets up the alias for showing the repo npm status
    _do_log_info "npm" "Initialize npm for '$repo'"
    _do_repo_cmd_hook_add "${repo}" "npm" "${_DO_NPM_REPO_CMDS}"

    _do_repo_alias_add $proj_dir $repo "npm" "uninit help clean build test"


    local name
    for name in $(_do_repo_dir_array_print "${repo}" "npm"); do
        _do_log_debug "npm" "  $repo/$name"

        if [ "$name" != "." ]; then 
            local cmd=$(_do_string_to_alias_name ${name})

            # Adds command to build a sub project
            alias "${repo}-npm-build-${cmd}"="_do_npm_repo_proj_cmd \"${proj_dir}\" \"${repo}\" \"${name}\" npm install"

            # Adds command to clean a sub project
            alias "${repo}-npm-clean-${cmd}"="_do_npm_repo_proj_cmd \"${proj_dir}\" \"${repo}\" \"${name}\" npm run clean"

            # Adds command to test a sub project
            alias "${repo}-npm-test-${cmd}"="_do_npm_repo_proj_cmd \"${proj_dir}\" \"${repo}\" \"${name}\" npm run test"
        fi
    done
}


# Runs any npm command in docker.
# Arguments:
#   1. repo: The repository name.
#
function _do_npm_repo_proj_cmd() {
    local proj_dir=${1?'proj_dir arg required'}
    shift

    local repo=${1?'repo arg required'}
    shift

    local dir=${1?'dir arg required'}
    shift

    local title="$repo: Runs $@ at ${dir}"
    _do_print_header_2 $title

    _do_dir_push "${proj_dir}/${repo}/${dir}"
    _do_print_line_1 "$@"

    eval "$@"
    local err=$?

    _do_dir_pop
    return $err
}
