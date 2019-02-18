DO_PLUGINS="test"

# Activates the environment with just the test plug
source activate.sh --quick

# Generates a new temp directory. All generated test files 
# will be stored in this directory. This directory will be cleaned
# up later once the test execution is finished.

function _do_test_start() {
    local dir=$DO_HOME/test

    # This is the generated bash file that will be 
    # call later. This fill will include the original test source file 
    # and some other automatically generated code for trigering the code. 
    local tmp_dir="$(_do_dir_random_tmp_dir)"
    local gen_f=$tmp_dir/do-test.sh
    local out_f=$tmp_dir/do-test-out.txt
    local err_f=$tmp_dir/do-test-err.tx
    local total_tests=0
    local total_failed=0
     
    # This regular expression will help to extract the function definition 
    # that begin with "test_" prefix. 
    local pattern='^[[:blank:]]*function[[:blank:]]*\(test_[^\(]*\).*$'

    cd $dir

    # Recursively looks for all test files that end with "-test.sh" and runs them.
    local file
    for file in $( find $(pwd) -type f -name "*-test.sh" ); do
        if [ -f $file ]; then 
            _do_print_header_1 "$file"

            # Extracts all test functions out of the original source file and 
            # generate function calls to those at the end of the generated test file.
            local funcs=$( cat $file | grep $pattern | sed -e "s/${pattern}/\1/" )

            local func
            for func in ${funcs[@]}; do 

                printf $func

                # Adds the code to activate both the framework and the test source file.
                echo "
source ${DO_HOME}/activate.sh --quick
source $file

_DO_TEST_TMP_DIR=${_DO_TEST_TMP_DIR}
$func
                " > $gen_f

                # Go to the temp directory
                cd ${tmp_dir}
           
                # Runs the original test file.
                bash $gen_f > $out_f 2> $err_f
                local err=$?

                if _do_error $err; then 
                    printf "...${FG_RED}Failed${FG_NORMAL}\n"
                    cat $out_f
                    cat $err_f
                    total_failed=$((total_failed + 1))
                else 
                    printf "...${FG_GREEN}OK${FG_NORMAL}\n"
                fi             

                total_tests=$((total_tests + 1))
            done 
        fi
    done

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
}


# Starts running the test cases
_do_test_start
