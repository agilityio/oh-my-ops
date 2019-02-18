
# Just loads the test plugin.
DO_PLUGINS="test"

# Activates the environment with just the test plug
source activate.sh --quick


# =============================================================================
# Parse input arguments.
# =============================================================================
# The remaining arguments that cannot be parsed.
test_dirs=()

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
            test_dirs+=("$1") # save it in an array for later
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


function _do_test_start() {
    # Needs to go to the current directories again 
    # To resolves the user input.
    cd $cur_dir &> /dev/null

    # This is the directory to resolve the test cases.
    local dir=$1

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
        
            _do_print_header_1 "$file"

            # Extracts all test functions out of the original source file and 
            # generate function calls to those at the end of the generated test file.
            local funcs=$( cat $file | grep $pattern | sed -e "s/${pattern}/\1/" )

            # Loops through all test functions found in the test file. For each 
            # of the function, generate a bash file to execute just that function.
            local func
            for func in ${funcs[@]}; do 

                printf $func

                # Generates the file that quickly activate the devops framework 
                # and include the orginal test source file and run the current test function.
                echo "
source ${DO_HOME}/activate.sh --quick
source $file
$func
                " > $gen_f

                # Go to the temp directory
                cd ${tmp_dir}
           
                # Runs the original test file and redirect standard out and error.
                bash $gen_f > $out_f 2> $err_f
                local err=$?

                if _do_error $err; then 
                    # The test has failed.
                    total_failed=$((total_failed + 1))

                    printf "...${FG_RED}Failed${FG_NORMAL}\n"
                    cat $out_f
                else 
                    # The test passed.
                    printf "...${FG_GREEN}OK${FG_NORMAL}\n"

                    if [ ${verbose} == "yes" ]; then 
                        cat $out_f
                    fi
                fi             
                cat $err_f

                total_tests=$((total_tests + 1))
            done 
        fi
    done

}


if [ ${#test_dirs[@]} -gt 0 ]; then 
    # If the test directories are passed in, just run tests on those directories.
    for dir in ${test_dirs[@]}; do 
        _do_test_start $dir
    done

else 
    # If the test directories are not passed in, just runs test on the current directory.
    _do_test_start .
fi 

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
    _do_print_finished "All ${total_tests} tests passed!"
    exit 0
fi 
