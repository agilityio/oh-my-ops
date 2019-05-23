# Gets the file name
# Arguments:
# 1. file: Required. The file to extract the name.
#
function _do_file_name() {
    local file="$1"
    echo "${file##*/}"   
}


# Gets the file name without extension
# Arguments:
# 1. name: Required. The file name.
#
function _do_file_name_without_ext() {
    local name="$(_do_file_name ${1?'name arg required'})"
    echo "${name%%.*}"   
}


# Gets a file extension
# Arguments:
# 1. name: Required. The file name.
#
function _do_file_ext() {
    local name="${1?'name arg required'}"
    echo "${name#*.}"   
}


# Asserts that the file exists.
# Arguments:
# 1. file: Required. The file name to check.
#
function _do_file_assert() {
    local file=${1?'file arg required'}

    [ -f $file ] || _do_assert_fail "Expected $file a file"
}


# Asserts that the specified file does not exist.
# Arguments:
# 1. file: Required. The file name to check.
#
function _do_file_assert_not() {
    local file=${1?'file arg required'}

    [ -f $file ] || _do_assert_fail "Expected $file not a file"
}


# Scans the specified directory recursively to find certain files.
# Arguments:
# 1. dir: Required. The directory to get the file for.
# 2. pattern: Required. The file name pattern expected by 'find' program.
#
function _do_file_scan() {
    local dir=${1?'dir arg required'}
    _do_dir_assert "${dir}"


    local pattern=${2?'pattern arg required'}

    _do_dir_push "${dir}"

    local name
    for name in $(find . -maxdepth 3 -type f -name "${pattern}" -print); do 
        # Removes the first 2 characters './'.
        echo $name | cut -c 3-
    done

    _do_dir_pop
}
