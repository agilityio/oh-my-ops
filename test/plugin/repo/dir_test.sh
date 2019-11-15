_do_plugin 'repo'

dir='fake/someone/lime'

# Makes sure repo directories can be added.
#
function test_repo_dir_add() {
    mkdir -p "${dir}/proj1/src/package1"
    mkdir -p "${dir}/proj1/src/abc"

    # Adds the root project
    _do_repo_dir_add "${dir}" || _do_assert_fail

    # Adds a sub project
    _do_repo_dir_add "${dir}/proj1" || _do_assert_fail

    # Adds a package to the project
    _do_repo_dir_add "${dir}/proj1/src/package1" || _do_assert_fail
}


function test_repo_dir_get() {
    test_repo_dir_add

    local dir=$(_do_repo_dir_get "lime-proj1") || _do_assert_fail
}


function test_repo_dir_list() {
    test_repo_dir_add

    local all_dirs=( $(_do_repo_dir_list) ) || _do_assert_fail
    _do_assert_eq "3" "${#all_dirs[@]}"
}


function test_repo_dir_list_filtered() {
    test_repo_dir_add

    local sub_dirs=( $(_do_repo_dir_list "${dir}/proj1") ) || _do_assert_fail
    _do_assert_eq "2" "${#sub_dirs[@]}"
}


function test_repo_name_list() {
    test_repo_dir_add

    _do_repo_name_list
    local names=( $(_do_repo_name_list) ) || _do_assert_fail
    _do_assert_eq "3" "${#names[@]}"

    # Converts to array data structure to verify content
    _do_array_new 'names' ${names[@]}
    _do_assert_eq "3" $(_do_array_size 'names')
    _do_array_print 'names'

    _do_array_contains 'names' 'lime' || _do_assert_fail
    _do_array_contains 'names' 'lime-proj1' || _do_assert_fail
    _do_array_contains 'names' 'lime-proj1-package1' || _do_assert_fail
}


function test_repo_name_list_filtered() {
    test_repo_dir_add

    _do_repo_name_list 'lime-proj1'
    local names=( $(_do_repo_name_list 'lime-proj1') ) || _do_assert_fail
    _do_assert_eq "2" "${#names[@]}"

    # Converts to array data structure to verify content
    _do_array_new 'names' ${names[@]}
    _do_assert_eq "2" $(_do_array_size 'names')
    _do_array_print 'names'

    _do_array_contains 'names' 'lime-proj1' || _do_assert_fail
    _do_array_contains 'names' 'lime-proj1-package1' || _do_assert_fail
}


function test_repo_list() {
    test_repo_dir_add

    echo "-- all repos --"

    # Reads out the repository line by line.
    while read -r repo; do 
        echo "repo: ${repo}"

        # For each line, convert two the array of 2 parts.
        # The first one should be the directory dir, and the second 
        # should be the directory name.
        local parts=( ${repo} )
        _do_assert_eq "2" "${#parts[@]}"

        echo "  dir: ${parts[0]}"
        echo "  name: ${parts[1]}"

    done <<< $(_do_repo_list)
}

# ==============================================================================
# Custom name test
# ==============================================================================

function test_repo_dir_add_custom() {
    mkdir -p "${dir}/proj1/src/package1"
    mkdir -p "${dir}/proj1/src/abc"

    # Adds the root project
    _do_repo_dir_add "${dir}" 'custom-lime' || _do_assert_fail

    # Adds a sub project
    _do_repo_dir_add "${dir}/proj1" 'custom-proj1' || _do_assert_fail

    # Adds a package to the project
    _do_repo_dir_add "${dir}/proj1/src/package1" 'custom-package1' || _do_assert_fail
}


function test_repo_dir_list_custom() {
    test_repo_dir_add_custom

    local all_dirs=( $(_do_repo_dir_list) ) || _do_assert_fail
    _do_assert_eq "3" "${#all_dirs[@]}"
}


function test_repo_dir_list_filtered_custom() {
    test_repo_dir_add

    local sub_dirs=( $(_do_repo_dir_list "${dir}/proj1") ) || _do_assert_fail
    _do_assert_eq "2" "${#sub_dirs[@]}"
}


function test_repo_list_custom() {
    test_repo_dir_add_custom

    echo "-- all repos --"

    # Reads out the repository line by line.
    while read -r repo; do 
        echo "repo: ${repo}"

        # For each line, convert two the array of 2 parts.
        # The first one should be the directory dir, and the second 
        # should be the directory name.
        local parts=( ${repo} )
        _do_assert_eq "2" "${#parts[@]}"

        echo "  dir: ${parts[0]}"
        echo "  name: ${parts[1]}"

    done <<< $(_do_repo_list)
}

function test_repo_name_list_custom() {
    test_repo_dir_add_custom

    _do_repo_name_list
    local names=( $(_do_repo_name_list) ) || _do_assert_fail
    _do_assert_eq "3" "${#names[@]}"

    # Converts to array data structure to verify content
    _do_array_new 'names' ${names[@]}
    _do_assert_eq "3" $(_do_array_size 'names')
    _do_array_print 'names'

    _do_array_contains 'names' 'custom-lime' || _do_assert_fail
    _do_array_contains 'names' 'custom-proj1' || _do_assert_fail
    _do_array_contains 'names' 'custom-package1' || _do_assert_fail
}


function test_repo_name_list_filtered() {
    test_repo_dir_add_custom

    _do_repo_name_list 'custom-proj1'
    local names=( $(_do_repo_name_list 'custom-proj1') ) || _do_assert_fail
    _do_assert_eq "2" "${#names[@]}"

    # Converts to array data structure to verify content
    _do_array_new 'names' ${names[@]}
    _do_assert_eq "2" $(_do_array_size 'names')
    _do_array_print 'names'

    _do_array_contains 'names' 'custom-proj1' || _do_assert_fail
    _do_array_contains 'names' 'custom-package1' || _do_assert_fail
}
