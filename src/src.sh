
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
function _do_src_dir() {
    local file=$(_do_src_file)
    dirname $file
}

# Gets the file name of the calling script.
function _do_src_name() {
    local file=$(_do_src_file)
    basename $file
}

# Includes other bash scripts in the same directory.
function _do_src_include_others_same_dir() {
    local dir=$(_do_src_dir)
    local excluded=$(_do_src_name)

    for name in $(ls $dir); do
        if [ ! "$name" == "$excluded" ]; then 
            source $dir/$name
        fi
    done
}
