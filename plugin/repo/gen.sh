
# Generates a new repository under the current project directory
#
function _do_repo_gen() {
    local repo=$1
    local proj_dir=$(_do_proj_default_get_dir)

    _do_print_header_2 "Generates new repository"

    # Reads the repository name from command line.
    if [ -z "$repo" ]; then 
        printf "Please enter repository name: "
        read repo
    fi 

    _do_log_info "proj" "Generates new repo '${repo}' at '${proj_dir}'"

    local repo_dir="${proj_dir}/${repo}"

    # Creates the repository directory
    mkdir ${repo_dir}
    cd $repo_dir

    # Makes the .do.sh file so that this repository is picked up 
    # by devops framework.
    touch .do.sh

    # Adds empty README file
    touch README.md

    # Trigger hook for other plugins to generate more.
    _do_hook_call "_do_repo_gen" "${proj_dir}" "${repo}"

    # Triggers additional init for the repository.
    _do_repo_init $proj_dir $repo
}

