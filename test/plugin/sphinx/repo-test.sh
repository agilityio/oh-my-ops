proj_dir=$(_do_dir_normalized $DO_HOME/..)
repo="devops"

# Builds still be fine because the comamnd should rebuild the image
build_dir="$proj_dir/$repo/doc/_build"

function test_do_sphinx_repo() {

    _do_sphinx_repo_help $proj_dir $repo 

    # makes sure sphinx stop
    _do_sphinx_repo_stop $proj_dir $repo 

    # Cleans the repository so that the _build dir is removed.
    _do_sphinx_repo_clean $proj_dir $repo 
    _do_dir_assert_not $build_dir 

    # Builds 
    _do_sphinx_repo_build $proj_dir $repo 
    _do_dir_assert $build_dir

    # Starts the web server
    _do_sphinx_repo_start $proj_dir $repo 

    # Display status, should be running
    _do_sphinx_repo_status $proj_dir $repo 

    # Stops the web server
    _do_sphinx_repo_stop $proj_dir $repo 

    # Should not running
    _do_sphinx_repo_status $proj_dir $repo 
}
