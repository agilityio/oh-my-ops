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

    _do_print_header_2 "$repo: Npm help"

    echo "  
  ${repo}-npm-help: 
    See npm command helps

  ${repo}-npm-clean: 
    Cleans npm build output

  ${repo}-npm-build: 
    Runs 'npm install'

  ${repo}-npm-status: 
    Displays the npm status."

    _do_dir_push $proj_dir/$repo

    for dir in $(_do_npm_repo_dir_print "${repo}"); do
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


# Prints out all sub directories in a repo that can be run 
# with npm.
# Arguments:
# 1. repo: Required. The repository name.
#
function _do_npm_repo_dir_print() {
    local repo=${1?'repo arg required'}
    _do_array_print "npm_${repo}"
}


# Cleans the repository npm output.
#
function _do_npm_repo_clean() {
    local proj_dir=$1
    local repo=$2

    if ! _do_npm_repo_enabled $proj_dir $repo; then 
        return
    fi 

    for dir in $(_do_npm_repo_dir_print "${repo}"); do
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
    for dir in $(_do_npm_repo_dir_print "${repo}"); do
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
    for dir in $(_do_npm_repo_dir_print "${repo}"); do
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

    if _do_array_exists "npm_${repo}"; then 
        return 0
    else 
        return 1
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
    if _do_array_exists "npm_${repo}"; then 
        _do_array_destroy "npm_${repo}"
    fi
}

# Scans the specified repository to find all sub directories that contains the
# package.json files (those from node_modules will be ignored)
# Arguments:
# 1. proj_dir: Required. The project directory.
# 2. repo: Required. The repository name.
#
function _do_npm_repo_scan() {
    local proj_dir=${1?'proj_dir argument required'}
    local repo=${2?'repo argument required'}

    _do_dir_push $proj_dir/$repo

    # Finds all directories that contains a package.json file and 
    # ignore node_modules directory if any.
    for name in $(find . -maxdepth 3 -type f -name 'package.json' ! -path '*/node_modules/*' -print); do 
        echo "$(dirname ${name})"
    done

    _do_dir_pop
} 

# Initializes npm support for a repository.
#
function _do_npm_repo_init() {
    local proj_dir=${1?'proj_dir argument required'}
    local repo=${2?'repo argument required'}

    local subs=( $(_do_npm_repo_scan "${proj_dir}" "${repo}") )
    if [ ${#subs[@]} -eq 0 ]; then 
        return 
    fi 

    _do_array_new "npm_${repo}" ${subs[@]}

    # Uninitializes the repository first
    # _do_npm_repo_uninit ${proj_dir} ${repo}

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

    _do_dir_push $proj_dir/$repo


    for name in $(_do_array_print "npm_${repo}"); do
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

    _do_dir_pop
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
