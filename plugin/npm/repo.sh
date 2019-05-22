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
    Builds npm documentation. The result is stored in doc/_build.

  ${repo}-npm-start: 
    Starts the npm web server as daemon, with live-reloading.

  ${repo}-npm-watch: 
    Watches the npm web server, with live-reloading.

  ${repo}-npm-stop: 
    Stops the npm web server.

  ${repo}-npm-status: 
    Displays the npm status.

  ${repo}-npm-web: 
    Opens the npm web page."
    _do_dir_push $proj_dir/$repo

    local name
    for name in $(find . -maxdepth 3 -type f -name 'package.json' -print); do 
        if [ -f "$name" ]; then 
            # Removes the main.npm out of the command name.
            local name=$(dirname ${name})

            # Removes the first 2 characters './'.
            name=$(echo $name | cut -c 3-)

            # Example: 
            #   for master/cmd/main.npm 
            #   the cmd will be "master-cmd"
            #
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

    _do_dir_pop
}


# Cleans the repository npm output.
#
function _do_npm_repo_clean() {
    local proj_dir=$1
    local repo=$2

    if ! _do_npm_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local title="$repo: cleans npm build result"
    _do_print_header_2 $title

    _do_repo_dir_push ${proj_dir} ${repo}

    _do_print_line_1 "npm clean"
    npm run clean 

    _do_dir_pop

    local err=$?
    _do_error_report $err "$title"
    return $err
}


# Builds the npm repository.
#
function _do_npm_repo_build() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    if ! _do_npm_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local title="$repo: Builds npm repository"
    _do_print_header_2 $title

    _do_npm_repo_venv_start "$proj_dir" "$repo"

    _do_repo_dir_push ${proj_dir} ${repo}

    _do_print_line_1 "npm install"
    npm install 

    _do_dir_pop

    _do_npm_repo_venv_stop "$proj_dir" "$repo"


    local err=$?
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

    return 0
    if [ -f "${proj_dir}/${repo}/npm.sln" ]; then 
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
}

# Initializes npm support for a repository.
#
function _do_npm_repo_init() {
    local proj_dir=${1?'proj_dir argument required'}
    local repo=${2?'repo argument required'}

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

    _do_repo_alias_add $proj_dir $repo "npm" "uninit help clean build cmd"

    _do_dir_push $proj_dir/$repo

    local name
    for name in $(find . -maxdepth 3 -type f -name 'package.json' -print); do 
        _do_log_debug "npm" "  $repo/$name"

        if [ -f "$name" ]; then 
            # Removes the main.npm out of the command name.
            local name=$(dirname ${name})

            # Removes the first 2 characters './'.
            name=$(echo $name | cut -c 3-)

            # Example: 
            #   for master/cmd/main.npm 
            #   the cmd will be "master-cmd"
            #
            local cmd=$(_do_string_to_alias_name ${name})

            # Adds command to build a sub project
            alias "${repo}-npm-build-${cmd}"="_do_npm_repo_proj_cmd ${proj_dir} ${repo} $name npm install"

            # Adds command to clean a sub project
            alias "${repo}-npm-clean-${cmd}"="_do_npm_repo_proj_cmd ${proj_dir} ${repo} $name npm run clean"

            # Adds command to test a sub project
            alias "${repo}-npm-test-${cmd}"="_do_npm_repo_proj_cmd ${proj_dir} ${repo} $name npm run test"
        fi
    done
    _do_dir_pop
}


# Runs any npm command in docker.
# Arguments:
#   1. repo: The repository name.
#
function _do_npm_repo_proj_cmd() {
    local proj_dir=$1
    shift

    local repo=$1
    shift

    local proj=$1
    shift

    _do_npm_repo_venv_start "$proj_dir" "$repo"

    _do_dir_push "$proj_dir/$repo/$proj"

    _do_print_line_1 "$@"
    eval "$@"

    _do_npm_repo_venv_stop "$proj_dir" "$repo"

    _do_dir_pop
    return $?
}
