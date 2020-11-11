# Generates firebase support for an existing repository.
# Arguments:
# 1. proj_dir: The project directory that this repository is in.
# 2. repo: The repository name.
#
function _do_firebase_repo_gen() {
    local proj_dir=${1?'proj_dir required'}
    local repo=${2?'repo required'}
    
    _do_print_line_1 "Generates firebase support"

    local repo_dir="${proj_dir}/${repo}"

    # Makes sure that the directory exists
    _do_dir_assert ${repo_dir}

    _do_dir_push "${repo_dir}"

    # Creates an empty firebase solution
    firebase new solution --name firebase
    echo "firebase.sln file added"
    local err=$?

    _do_dir_pop

    _do_firebase_repo_init ${proj_dir} ${repo}
    _do_firebase_repo_help ${proj_dir} ${repo}

    return $err
}
