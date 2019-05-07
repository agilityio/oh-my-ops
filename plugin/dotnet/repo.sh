_DO_DOTNET_REPO_CMDS="help clean build"
_DO_DOTNET_PATHS=()

# Displays helps about how to run a repository dotnet commands.
#
function _do_dotnet_repo_help() {
    local proj_dir=$1
    local repo=$2
    
    if ! _do_dotnet_repo_enabled $proj_dir $repo; then 
        return
    fi 

    _do_print_header_2 "$repo: Dotnet help"

    echo "  
  ${repo}-dotnet-help: 
    See dotnet command helps

  ${repo}-dotnet-clean: 
    Cleans dotnet build output

  ${repo}-dotnet-build: 
    Builds dotnet documentation. The result is stored in doc/_build.

  ${repo}-dotnet-start: 
    Starts the dotnet web server as daemon, with live-reloading.

  ${repo}-dotnet-watch: 
    Watches the dotnet web server, with live-reloading.

  ${repo}-dotnet-stop: 
    Stops the dotnet web server.

  ${repo}-dotnet-status: 
    Displays the dotnet status.

  ${repo}-dotnet-web: 
    Opens the dotnet web page."
    _do_dir_push $proj_dir/$repo/src

    local name
    for name in $(find . -depth 2 -name *.csproj -print); do 
        if [ -f "$name" ]; then 
            # Removes the main.dotnet out of the command name.
            local name=$(dirname ${name})

            # Removes the first 2 characters './'.
            name=$(echo $name | cut -c 3-)

            # Example: 
            #   for master/cmd/main.dotnet 
            #   the cmd will be "master-cmd"
            #
            local cmd=$(_do_string_to_dash ${name})
            echo "  
  ${repo}-dotnet-clean-${cmd}:
    Runs dotnet clean on $name

  ${repo}-dotnet-build-${cmd}:
    Runs dotnet build on $name

  ${repo}-dotnet-test-${cmd}:
    Runs dotnet test on $name"
        fi
    done

    _do_dir_pop
}


# Cleans the repository dotnet output.
#
function _do_dotnet_repo_clean() {
    local proj_dir=$1
    local repo=$2

    if ! _do_dotnet_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local title="$repo: cleans dotnet build result"
    _do_print_header_2 $title

    _do_repo_dir_push ${proj_dir} ${repo}

    _do_print_line_1 "dotnet clean"
    dotnet build 

    _do_dir_pop

    local err=$?
    _do_error_report $err "$title"
    return $err
}


# Builds the dotnet repository.
#
function _do_dotnet_repo_build() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    if ! _do_dotnet_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local title="$repo: Builds dotnet repository"
    _do_print_header_2 $title

    _do_dotnet_repo_venv_start "$proj_dir" "$repo"

    _do_repo_dir_push ${proj_dir} ${repo}

    _do_print_line_1 "dotnet build"
    dotnet build 

    _do_dir_pop

    _do_dotnet_repo_venv_stop "$proj_dir" "$repo"


    local err=$?
    _do_error_report $err "$title"
    return $err
}


# Determines if the specified directory has dotnet enabled.
# Arguments:
#   1. dir: A directory.
# 
# Returns: 
#   0 if dotnet enabled, 1 otherwise.
#
function _do_dotnet_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if [ -f "${proj_dir}/${repo}/dotnet.sln" ]; then 
        return 0
    else 
        return 1
    fi 
}

function _do_dotnet_repo_uninit() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)

    # Removes all unalias
    _do_alias_remove_by_prefix "${repo}-${dotnet}"

    # Just keeps init alias so that it can be reinitialized
    _do_repo_alias_add ${proj_dir} ${repo} "dotnet" "init"
    _do_repo_cmd_hook_remove "${repo}" "dotnet" "${_DO_DOTNET_REPO_CMDS}"
}

# Initializes dotnet support for a repository.
#
function _do_dotnet_repo_init() {
    local proj_dir=${1?'proj_dir argument required'}
    local repo=${2?'repo argument required'}

    # Uninitializes the repository first
    _do_dotnet_repo_uninit ${proj_dir} ${repo}

    if ! _do_dotnet_repo_enabled ${proj_dir} ${repo}; then 
        # Adds alias for generating dotnet project.
        _do_repo_alias_add $proj_dir $repo "dotnet" "gen"
        
        _do_log_debug "dotnet" "Skips dotnet support for '$repo'"
        # This directory does not have dotnet support.
        return
    fi 

    # Sets up the alias for showing the repo dotnet status
    _do_log_info "dotnet" "Initialize dotnet for '$repo'"
    _do_repo_cmd_hook_add "${repo}" "dotnet" "${_DO_DOTNET_REPO_CMDS}"

    _do_repo_alias_add $proj_dir $repo "dotnet" "uninit help clean build cmd"

    _do_dir_push $proj_dir/$repo/src

    local name
    for name in $(find . -depth 2 -name *.csproj -print); do 
        _do_log_debug "dotnet" "  $repo/$name"

        if [ -f "$name" ]; then 
            # Removes the main.dotnet out of the command name.
            local name=$(dirname ${name})

            # Removes the first 2 characters './'.
            name=$(echo $name | cut -c 3-)

            # Example: 
            #   for master/cmd/main.dotnet 
            #   the cmd will be "master-cmd"
            #
            local cmd=$(_do_string_to_dash ${name})

            # Adds command to build a sub project
            alias "${repo}-dotnet-build-${cmd}"="_do_dotnet_repo_proj_cmd ${proj_dir} ${repo} $name dotnet build"

            # Adds command to clean a sub project
            alias "${repo}-dotnet-clean-${cmd}"="_do_dotnet_repo_proj_cmd ${proj_dir} ${repo} $name dotnet clean"

            # Adds command to test a sub project
            alias "${repo}-dotnet-test-${cmd}"="_do_dotnet_repo_proj_cmd ${proj_dir} ${repo} $name dotnet test"
        fi
    done
    _do_dir_pop
}


# Runs any dotnet command in docker.
# Arguments:
#   1. repo: The repository name.
#
function _do_dotnet_repo_proj_cmd() {
    local proj_dir=$1
    shift

    local repo=$1
    shift

    local proj=$1
    shift

    _do_dotnet_repo_venv_start "$proj_dir" "$repo"

    _do_dir_push "$proj_dir/$repo/src/$proj"

    _do_print_line_1 "$@"
    eval "$@"

    _do_dotnet_repo_venv_stop "$proj_dir" "$repo"

    _do_dir_pop
    return $?
}
