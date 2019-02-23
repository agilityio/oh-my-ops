_do_log_level_warn "sphinx"


# Listens to the _do_repo_gen hook and generates sphinx support.
#
function _do_sphinx_repo_gen() {
    local proj_dir=$(_do_arg_required $1)
    local repo=$(_do_arg_required $2)
        
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
