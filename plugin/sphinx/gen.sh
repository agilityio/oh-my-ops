_do_log_level_warn "sphinx"


# Listens to the _do_repo_gen hook and generates sphinx support.
#
function _do_sphinx_repo_gen() {
    local proj_dir=${1?'proj_dir arg required'}
    local repo=${2?'repo arg required'}
        
    _do_log_info "sphinx" "Generates sphinx support"

    local doc_dir="${proj_dir}/${repo}/doc"
    mkdir ${doc_dir}

    echo "project = 'Devops'" > $doc_dir/conf.py
    echo "
${repo}
==============
    " > $doc_dir/index.rst

    _do_repo_dir_push $proj_dir $repo
   
    _do_dir_pop
}
