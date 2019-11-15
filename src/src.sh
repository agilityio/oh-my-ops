
# Find the directory of the calling script
function _do_src_file() {
    local i=

    # Walks the stack trace and find the first source
    # that is not from this plugin.
    while ! [ -z "${BASH_SOURCE[$i]:-}" ]
    do
        local src="${BASH_SOURCE[$i]}"
        local func="${FUNCNAME[$i]}"
        if ! [[ "$func" =~ "_do_src_" ]]; then 
            echo "$src"
            return
        fi
        i=$((i + 1))
    done | grep -v "^$BASH_SOURCE"
}


# Gets the base dir of the calling script.
# Arguments: None
#
function _do_src_dir() {
    local file=$(_do_src_file)
    dirname $file
}


# Gets the file name of the calling script.
# Arguments: None
#
function _do_src_name() {
    local file=$(_do_src_file)
    basename $file
}


# Includes other bash scripts in the same directory.
# Arguments: None
#
function _do_src_include_others_same_dir() {
    local dir=$(_do_src_dir)
    local excluded=$(_do_src_name)

    _do_dir_push $dir

    local name
    for name in $(ls -A *.sh); do
        if [ -f "./$name" ] && [ ! "$name" == "$excluded" ]; then 
            source ./$name
        fi
    done
    _do_dir_pop
}


# Loads all source files that match the search condition.
# Arguments:
# - ...: Required. The list of files, directories, or search pattern to load
# the source files.
#
function _do_src_include() {
    # Makes sure there is at least 1 source file to load
    : ${1?'files arg required'}

    # This is the source directory of the file that 
    # call this script.
    local dir=$(_do_src_dir)

    # Changes to the directory relative to the calling script.
    _do_dir_push "${dir}" 

    while (( $# > 0 )); do
        if [ -f "$1" ]; then 
            # This is a file to include.
            source "$1"
        else 
            # This is directory to include
            for name in $(ls -A $1/*.sh); do
                if [ -f "./$name" ];  then 
                    source "$name"
                fi
            done
        fi

        shift 1
    done

    _do_dir_pop
}
