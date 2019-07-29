# To generates this logo
# http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=oh-my-ops
#
function _do_print_banner() {
    echo -e "${_DO_FG_ENVIRONMENT}


   ██████╗ ██╗  ██╗      ███╗   ███╗██╗   ██╗      ██████╗ ██████╗ ███████╗
  ██╔═══██╗██║  ██║      ████╗ ████║╚██╗ ██╔╝     ██╔═══██╗██╔══██╗██╔════╝
  ██║   ██║███████║█████╗██╔████╔██║ ╚████╔╝█████╗██║   ██║██████╔╝███████╗
  ██║   ██║██╔══██║╚════╝██║╚██╔╝██║  ╚██╔╝ ╚════╝██║   ██║██╔═══╝ ╚════██║
  ╚██████╔╝██║  ██║      ██║ ╚═╝ ██║   ██║        ╚██████╔╝██║     ███████║
   ╚═════╝ ╚═╝  ╚═╝      ╚═╝     ╚═╝   ╚═╝         ╚═════╝ ╚═╝     ╚══════╝
        $@
------------------------------------------------------------------------------${_DO_FG_NORMAL}"
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
    if [ ${#msg} -lt 79 ]; then
        local line=$(printf '%0.1s' "${char}"{1..78})   
        pad=${line:${#msg}}
    fi

    printf "${color}%s%s${_DO_FG_NORMAL}\n" "$msg" "${pad}"
}

function _do_print_line_1() {
    _do_print_line "-" "${_DO_FG_BLUE}" "$@"
}

function _do_print_line_2() {
    _do_print_line "=" "${_DO_FG_BLUE}" "$@"
}


function _do_print_color {
  local color=$1
  shift 1
  echo -e "${color}$@${_DO_FG_BLACK}"
}

function _do_print_blue {
  _do_print_color ${_DO_FG_BLUE} $@
}

function _do_print_yellow {
  _do_print_color ${_DO_FG_YELLOW} $@
}


function _do_print_header_1() {
    echo -e "${_DO_FG_BLUE}-------------------------------------------------------------------------------
    $@
-------------------------------------------------------------------------------${_DO_FG_NORMAL}"
}

function _do_print_header_2() {
    echo -e "${_DO_FG_BLUE}==============================================================================
    $@
==============================================================================${_DO_FG_NORMAL}"
}

function _do_print_warn() {
    echo -e "${_DO_FG_YELLOW}******************************************************************************
    $@
******************************************************************************${_DO_FG_NORMAL}"
}

function _do_print_error() {
    echo -e "${_DO_FG_RED}??????????????????????????????????????????????????????????????????????????????
    ERROR: $@
??????????????????????????????????????????????????????????????????????????????${_DO_FG_NORMAL}"
}

function _do_print_no_support() {
    _do_print_warn -e "${_DO_FG_YELLOW}WARNING! Skipped, no support for $ENVIRONMENT environment${_DO_FG_NORMAL}"
}

function _do_print_success() {

    echo -e "${_DO_FG_GREEN}------------------------------------------------------------------------------
    $@
------------------------------------------------------------------------------${_DO_FG_NORMAL}"
}
