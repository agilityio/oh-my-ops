
# Generates a new repository under the current project directory
#
# Arguments:
#   1. proj_dir: The project root directory.
#   2. repo: Optional. The repository name to generate.
#
function _do_repo_gen() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}

    _do_log_debug "repo" "proj_dir: ${proj_dir}. repo: ${repo}"

    # Makes sure that the project directory exists.
    _do_dir_assert "${proj_dir}"

    _do_print_header_2 "Generates new repository"

    # Reads the repository name from command line.
    if [ -z "$repo" ]; then 
        printf "Please enter repository name: "
        read repo
    fi 

    # Makes sure that the given repository directory does not exists.
    local repo_dir="${proj_dir}/${repo}"
    _do_dir_assert_not "${repo_dir}"

    _do_log_info "repo" "Generates new repo '${repo}' at '${proj_dir}'"

    # Creates the repository directory
    mkdir "${repo_dir}"

    _do_dir_push "${repo_dir}"

    # This is the src dir that contains whatever src files.
    mkdir src

    # Makes the .do.sh file so that this repository is picked up 
    # by devops framework.
    local func="_do_$(_do_string_to_undercase $repo)_repo_plugin" 
    echo "
_do_log_level_info \"${repo}\"


# This function is called when the repository first loaded.
function ${func}_init() {
    _do_log_info \"${repo}\" \"Initialized.\"
}
" > .do.sh 

    # Adds empty README file
    touch README.md

    echo 'root = true
[*]
indent_style = space
indent_size = 4
charset = utf-8
trim_trailing_whitespace = false
insert_final_newline = true
    ' > .editorconfig
    
    echo '* text auto
*.sh text eol=lf
    ' > .gitattributes

    echo '' > .gitignore

    _do_dir_pop

    # Trigger hook for other plugins to generate more.
    _do_hook_call "_do_repo_gen" "${proj_dir}" "${repo}"

    # Triggers additional init for the repository.
    _do_repo_init "${proj_dir}" "${repo}"
}

