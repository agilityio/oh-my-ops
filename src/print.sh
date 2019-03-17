function _do_print_banner() {
    echo -e "${FG_ENVIRONMENT}

    ██████╗ ███████╗██╗   ██╗ ██████╗ ██████╗ ███████╗
    ██╔══██╗██╔════╝██║   ██║██╔═══██╗██╔══██╗██╔════╝
    ██║  ██║█████╗  ██║   ██║██║   ██║██████╔╝███████╗
    ██║  ██║██╔══╝  ╚██╗ ██╔╝██║   ██║██╔═══╝ ╚════██║
    ██████╔╝███████╗ ╚████╔╝ ╚██████╔╝██║     ███████║
    ╚═════╝ ╚══════╝  ╚═══╝   ╚═════╝ ╚═╝     ╚══════╝

        $@
-------------------------------------------------------------------------------${FG_NORMAL}"
}

# Prints blank line(s)
#
# Arguments:
#   1. (optional) The number of blank lines to print. Default to 1.
#
function _do_print_blank_line() {
    local n=$1

    if [ -z "${n}" ]; then 
        let n=1
    fi 

    while (( ${n} > 0 ))
    do
        let n=${n}-1
        echo ""
    done
}

function _do_print_line() {
    local char=$1
    local color=$2
    local msg=${3:-}

    if [ ! -z "${msg}" ]; then 
        msg="${msg} "
    fi 

    local pad=""
    if [ ${#msg} -lt 80 ]; then
        local line=$(printf '%0.1s' "${char}"{1..79})   
        pad=${line:${#msg}}
    fi

    printf "${color}%s%s${FG_NORMAL}\n" "$msg" "${pad}"
}

function _do_print_line_1() {
    _do_print_line "-" "${FG_BLUE}" "$@"
}

function _do_print_line_2() {
    _do_print_line "=" "${FG_BLUE}" "$@"
}

function _do_print_header_1() {
    echo -e "${FG_BLUE}-------------------------------------------------------------------------------
    $@
-------------------------------------------------------------------------------${FG_NORMAL}"
}

function _do_print_header_2() {
    echo -e "${FG_BLUE}===============================================================================
    $@
===============================================================================${FG_NORMAL}"
}

function _do_print_warn() {
    echo -e "${FG_YELLOW}*******************************************************************************
    $@
*******************************************************************************${FG_NORMAL}"
}

function _do_print_error() {
    echo -e "${FG_RED}???????????????????????????????????????????????????????????????????????????????
    ERROR: $@
???????????????????????????????????????????????????????????????????????????????${FG_NORMAL}"
}

function _do_print_no_support() {
    _do_print_warn -e "${FG_YELLOW}WARNING! Skipped, no support for $ENVIRONMENT environment${FG_NORMAL}"
}

function _do_print_finished() {

    echo -e "${FG_GREEN}-------------------------------------------------------------------------------
    $@
-------------------------------------------------------------------------------${FG_NORMAL}"
}
