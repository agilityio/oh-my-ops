_DO_DOTNET_REPO_CMDS="help clean build test"

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
  do-${repo}-dotnet-help: 
    See dotnet command helps

  do-${repo}-dotnet-clean: 
    Cleans dotnet build output.

  do-${repo}-dotnet-build: 
    Builds dotnet repository.

  do-${repo}-dotnet-start: 
    Starts the dotnet web server as daemon, with live-reloading.

  do-${repo}-dotnet-watch: 
    Watches the dotnet web server, with live-reloading.

  do-${repo}-dotnet-stop: 
    Stops the dotnet web server.

  do-${repo}-dotnet-status: 
    Displays the dotnet status.

  do-${repo}-dotnet-web: 
    Opens the dotnet web page."

    # Prints out all aliases for solution files
    for name in $(_do_repo_dir_array_print "${repo}" "dotnet-sln"); do
        if [ "$name" != "." ]; then 
            local cmd=$(_do_string_to_alias_name ${name})
            echo "  
  do-${repo}-dotnet-clean-${cmd}:
    Runs dotnet clean on $name

  do-${repo}-dotnet-build-${cmd}:
    Runs dotnet build on $name

  do-${repo}-dotnet-test-${cmd}:
    Runs dotnet test on $name"
        fi
    done


    # Prints out all aliases for project files
    for name in $(_do_repo_dir_array_print "${repo}" "dotnet-csproj"); do
        if [ "$name" != "." ]; then 
            local cmd=$(_do_string_to_alias_name ${name})
            echo "  
  do-${repo}-dotnet-clean-${cmd}:
    Runs dotnet clean on $name

  do-${repo}-dotnet-build-${cmd}:
    Runs dotnet build on $name

  do-${repo}-dotnet-test-${cmd}:
    Runs dotnet test on $name"
        fi
    done
}

# Builds the dotnet repository.
#
function _do_dotnet_repo_clean() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    _do_dotnet_repo_cmd "${proj_dir}" "${repo}" dotnet clean
}


# Builds the dotnet repository.
#
function _do_dotnet_repo_build() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    _do_dotnet_repo_cmd "${proj_dir}" "${repo}" dotnet build
}


# Builds the dotnet repository.
#
function _do_dotnet_repo_test() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    _do_dotnet_repo_cmd "${proj_dir}" "${repo}" dotnet test
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

    if _do_repo_dir_array_is_empty "${repo}" "dotnet-sln" && _do_repo_dir_array_is_empty "${repo}" "dotnet-csproj"; then 
        return 1
    else 
        return 0
    fi 
}


function _do_dotnet_repo_uninit() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    # Removes all unalias
    _do_alias_remove_by_prefix "${repo}-dotnet"
    _do_repo_cmd_hook_remove "${repo}" "dotnet" "${_DO_DOTNET_REPO_CMDS}"

    # Just keeps init alias so that it can be reinitialized
    _do_repo_alias_add ${proj_dir} ${repo} "dotnet" "init"

    if _do_repo_dir_array_exists "${repo}" "dotnet-sln"; then 
        _do_repo_dir_array_destroy "${repo}" "dotnet-sln"
    fi

    if _do_repo_dir_array_exists "${repo}" "dotnet-csproj"; then 
        _do_repo_dir_array_destroy "${repo}" "dotnet-csproj"
    fi
}


# Initializes dotnet support for a repository.
#
function _do_dotnet_repo_init() {
    local proj_dir=${1?'proj_dir argument required'}
    local repo=${2?'repo argument required'}

    # Uninits the repository first.
    _do_dotnet_repo_uninit ${proj_dir} ${repo}

    # Scans the repository to find all dotnet projects and solution files.
    _do_repo_dir_array_new "${proj_dir}" "${repo}" "dotnet-csproj" "*.csproj"

    _do_repo_dir_array_new "${proj_dir}" "${repo}" "dotnet-sln" "*.sln"

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

    _do_repo_alias_add ${proj_dir} $repo "dotnet" "uninit help clean build test cmd"


    local name
    for name in $(_do_repo_dir_array_print "${repo}" "dotnet-sln"); do
        _do_log_debug "dotnet" "  $repo/$name"

        if [ "$name" != "." ]; then 
            local cmd=$(_do_string_to_alias_name ${name})

            # Adds command to build a sub project
            alias "do-${repo}-dotnet-build-${cmd}"="_do_dotnet_repo_proj_cmd ${proj_dir} ${repo} $name dotnet build"

            # Adds command to clean a sub project
            alias "do-${repo}-dotnet-clean-${cmd}"="_do_dotnet_repo_proj_cmd ${proj_dir} ${repo} $name dotnet clean"

            # Adds command to test a sub project
            alias "do-${repo}-dotnet-test-${cmd}"="_do_dotnet_repo_proj_cmd ${proj_dir} ${repo} $name dotnet test"
        fi
    done


    local name
    for name in $(_do_repo_dir_array_print "${repo}" "dotnet-csproj"); do
        _do_log_debug "dotnet" "  $repo/$name"

        if [ "$name" != "." ]; then 
            local cmd=$(_do_string_to_alias_name ${name})

            # Adds command to build a sub project
            alias "do-${repo}-dotnet-build-${cmd}"="_do_dotnet_repo_proj_cmd ${proj_dir} ${repo} $name dotnet build"

            # Adds command to clean a sub project
            alias "do-${repo}-dotnet-clean-${cmd}"="_do_dotnet_repo_proj_cmd ${proj_dir} ${repo} $name dotnet clean"

            # Adds command to test a sub project
            alias "do-${repo}-dotnet-test-${cmd}"="_do_dotnet_repo_proj_cmd ${proj_dir} ${repo} $name dotnet test"
        fi
    done
}



# Builds the dotnet repository.
#
function _do_dotnet_repo_cmd() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
    shift 2

    if ! _do_dotnet_repo_enabled $proj_dir $repo; then 
        return
    fi 

    local err=0
    for dir in $(_do_repo_dir_array_print "${repo}" "dotnet-sln"); do
        _do_dotnet_repo_proj_cmd "${proj_dir}" "${repo}" "${dir}" $@ || err=1
    done

    _do_error_report $err "$title"
    return $err
}


# Runs any dotnet command in docker.
# Arguments:
#   1. repo: The repository name.
#
function _do_dotnet_repo_proj_cmd() {
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
