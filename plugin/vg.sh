_do_plugin "proj"

# Docker Supports
_do_log_level_debug "vg"


# ==============================================================================
# Proj plugin integration
# ==============================================================================

# The array of all plugin repo comamnds.
_DO_VG_REPO_CMDS=( "help" "start" "stop" "ssh" "destroy" )


# If the specified repository has a file "Dockerfile", vg is enabled for 
# the repository. 
#
function _do_vg_repo_enabled() {
    local proj_dir=$1
    local repo=$2

    if [ -f "${proj_dir}/${repo}/Vagrantfile" ]; then 
        # Vagrant integration is enabled for this repository.
        return 0
    else
        return 1
    fi
}
 
# Initializes vg support for a repository.
#
function _do_vg_repo_init() {
    local proj_dir=$1
    local repo=$2

    if ! _do_vg_repo_enabled "${proj_dir}" "${repo}"; then 
        return
    fi

    _do_log_debug "vg" "Initializes vg integration for $repo"

    # Registers tmux command such as 'repo-tmux-start', etc.
    _do_repo_plugin "${proj_dir}" "${repo}" "vg" _DO_VG_REPO_CMDS 
}


# Displays helps for vg supports.
#
function _do_vg_repo_help() {
    local proj_dir=$1
    local repo=$2
    local mode=$3

    if [ "${mode}" = "--short" ]; then 
        echo "  ${repo}-vg-help: See vg command helps"
        return
    fi 

    echo -e "Vagrant Helps
    ${repo}-vg-help:
        Prints this help.

    ${repo}-vg-start:
        Vagrant up the machine.

    ${repo}-vg-stop:
        Vagrant down the machine.

    ${repo}-vg-ssh:
        Ssh into the vagrant machine.

    ${repo}-vg-destroy:
        Destroy the vagrant machine.
    "
}

# Starts vagrant machine.
function _do_vg_repo_start() {
    _do_repo_cmd $@ "vagrant up"
}

# Stops vagrant machine.
function _do_vg_repo_stop() {
    _do_repo_cmd $@ "vagrant halt"
}

# Ssh to vagrant machine.
function _do_vg_repo_ssh() {
    _do_repo_cmd $@ "vagrant ssh"
}

# Destroy vagrant machine.
function _do_vg_repo_destroy() {
    _do_repo_cmd $@ "vagrant destroy"
}

# ==============================================================================
# Plugin Init
# ==============================================================================
function _do_vg_plugin_init() {
    _do_log_info "vg" "Initialize plugin"
    
}

# Listens to init proj repo hook.
_do_proj_plugin "vg"
