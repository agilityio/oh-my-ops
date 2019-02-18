# Activates the environment
source activate.sh


function __test_start() {
    for file in $(ls -A $DO_HOME/test); do
        if [ -f $file ]; then 
            source $file
        fi
    done

    # Finds all test funcs available in the system
    compgen -A function | grep "^_do_test_" | while read func; do 
        printf "Running $func"
        $func
        printf "...${FG_GREEN}Ok${FG_NORMAL}\n"
    done    


    # All tests passed
    printf "${FG_GREEN}All Tests Passed!${FG_NORMAL}\n"
}


function __test_exit() {
    local err=$?

    if _do_error $err; then 
        printf "${FG_RED}Test Failed!${FG_NORMAL}\n"
    fi    
}


# Traps test failed
trap __test_exit EXIT

# Starts running the test case
__test_start
