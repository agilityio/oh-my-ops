# Activates the environment with just the test plug
source ${DO_HOME}/activate.sh --quick --no-log --no-plugins



# =============================================================================
# Parse input arguments.
# =============================================================================
# The remaining arguments that cannot be parsed.
test_args=()

# 0 Indicates this is a quick boot.
verbose="no"

# Parses the arguments parsed to this script.
#
function _do_test_parse_args() {
    # Parse input arguments
    while [[ $# -gt 0 ]]
    do
        key="$1"
        case $key in
            -v|--verbose)
            verbose="yes"
            shift
            ;;

            *)    # unknown option
            test_args+=("$1") # save it in an array for later
            shift # past argument
            ;;
        esac
    done
}

_do_test_parse_args $@


# =============================================================================
# Executes the test suite 
# =============================================================================

# This is the generated bash file that will be 
# call later. This fill will include the original test source file 
# and some other automatically generated code for trigering the code. 
cur_dir=$(pwd)
tmp_dir="$(_do_dir_random_tmp_dir)"
gen_f=$tmp_dir/do-test.sh
out_f=$tmp_dir/do-test-out.txt
err_f=$tmp_dir/do-test-err.tx

# The statistics about test result.
total_tests=0
total_failed=0

# This regular expression will help to extract the function definition 
# that begin with "test_" prefix. 
pattern='^[[:blank:]]*function[[:blank:]]*\(test_[^\(]*\).*$'
line=$(printf '%0.1s' "."{1..75})   


function _do_test_run_file {
    local file=$1
    _do_file_assert $file

    local only_func=$2

    _do_print_header_1 "$file"

    # Extracts all test functions out of the original source file and 
    # generate function calls to those at the end of the generated test file.
    local funcs=$( cat $file | grep $pattern | sed -e "s/${pattern}/\1/" )

    # Loops through all test functions found in the test file. For each 
    # of the function, generate a bash file to execute just that function.
    local func
    for func in ${funcs[@]}; do 
        if [ "${func}" == "test_setup" ] || [ "${func}" == "test_teardown" ]; then 
            # Skips test_setup and test_teardown function
            continue
        fi 

        if [ ! -z "$only_func" ] && [ "${func}" != "${only_func}" ]; then 
            # Skips the current function because the "only_func" argument is passed in.
            continue
        fi 

        pad=${line:${#func}}
        printf "%s ${_DO_TX_DIM}%s${_DO_FG_NORMAL}" "$func" "${pad}"

        # Generates the file that quickly activate the devops framework 
        # and include the orginal test source file and run the current test function.
        echo "
source ${DO_HOME}/activate.sh --quick

source $file

if type test_setup &>/dev/null; then 
    test_setup
fi

$func
err=$?

if type test_teardown &>/dev/null; then 
    test_teardown 
fi

exit $?

        " > $gen_f

        # Go to the temp directory
        cd ${tmp_dir}

        # Runs the original test file and redirect standard out and error.
        bash $gen_f > $out_f 2> $err_f
        local err=$?

        if _do_error $err; then 
            # The test has failed.
            total_failed=$((total_failed + 1))

            printf "[${_DO_FG_RED}F${_DO_FG_NORMAL}]\n"
            cat $out_f
        else 
            # The test passed.
            printf "[${_DO_FG_GREEN}P${_DO_FG_NORMAL}]\n"

            if [ ${verbose} == "yes" ]; then 
                cat $out_f
            fi
        fi             
        cat $err_f

        total_tests=$((total_tests + 1))
    done 

}


# Runs the test on the specified directory. It should scan the directory and its 
# children and looks for any file with name started with "-test.sh". All test 
# functions found in that directory should be executed, unless the "only_func" argument
# is passed in. 
# Arguments:
#   1. dir: The directory to run.
#   2. only_func: optional. 
#
function _do_test_run_dir() {
    # Needs to go to the current directories again 
    # To resolves the user input.
    cd $cur_dir &> /dev/null

    # This is the directory to resolve the test cases.
    local dir=$1
    local only_func=$2

    # Go to this directory to make sure the find command return the absolute path.
    cd $dir &> /dev/null
    local err=$?

    if _do_error $err; then 
        _do_assert_fail "Expected a $dir is a directory"
    fi 


    # Recursively looks for all test files that end with "-test.sh" and runs them.
    local file
    for file in $( find $(pwd) -type f -name "*-test.sh" ); do
        if [ -f $file ]; then 
            _do_test_run_file $file $only_func
        fi 
    done
}

# Runs the full tests, given the arguments parsed earlier.
#
function _do_test_run() {
    if [ ${#test_args[@]} -gt 0 ]; then 
        # If the test directories are passed in, just run tests on those directories.

        local arg
        for arg in ${test_args[@]}; do 
            # Gets out the test function if any.
            IFS="#" read -ra parts <<< "${arg}"
            arg=${parts[0]}
            func=${parts[1]}

            if [ -f $cur_dir/$arg ]; then 
                # If the argument is just a file, run the file only
                _do_test_run_file $cur_dir/$arg $func

            else
                # Runs all the file found in the argument.
                _do_test_run_dir $arg $func
            fi 
        done

    else 
        # If the test directories are not passed in, just runs test on the current directory.
        _do_test_run_dir .
    fi 
}

_do_test_run

# =============================================================================
# Teardown the test suite
# =============================================================================

# Deletes all generated files
rm -rfd $tmp_dir &> /dev/null

# All tests passed
if [ $total_failed -gt 0 ]; then 
    _do_print_error "Fail ${total_failed} of total ${total_tests} tests!"
    exit 1
else 
    _do_print_success "All ${total_tests} tests passed!"
    exit 0
fi 
