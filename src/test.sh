# Thanks for the inspiration from https://github.com/pgrange/bash_unit/blob/master/bash_unit
# This provides a unit testing framework for bash development.
#
# WIP: Need to rething this one.

function _do_test() {
    # Finds all test funcs available in the system
    compgen -A function | grep "^_do_test_" | while read func; do 
        echo "Running $func"
        $func
        local err=$?

        echo "HERE"

        echo "HERE: $err"

        if _do_error "$err"; then 
            echo "HERE"
        else 
            echo "FAILED HERE"
        fi
        
    done
}


function _do_test_abc() {
    _do_assert_eq "A" "B" "Really bad"
    _do_assert_eq "A" "A" 
    _do_assert_neq "A" "A"
    _do_assert_neq "A" "A" "Really bad"
    _do_assert_fail
}
