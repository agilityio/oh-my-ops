
# The current working environment.
DO_ENVIRONMENT="local"
_DO_PROMPT_DIR=""

# This function is called whenever the current directory changed. 
# 
function _do_prompt() {
    local dir=$(pwd)


    if [ "$dir" == "$_DO_PROMPT_DIR" ]; then 
        return
    fi 

    # Current directory has been changed
    _DO_PROMPT_DIR="${dir}"

    # Triggers hook for other plugin to process
    _do_hook_call "_do_prompt" $dir

    local environment="\[${_DO_TX_NORMAL} ${_DO_TX_BOLD}${_DO_FG_ENVIRONMENT}${_DO_TX_REVERSED}\] ${DO_ENVIRONMENT} \[${_DO_TX_NORMAL}\]"

    local text
    if [ -d ".git" ]; then
        local branch=$(git status | grep 'On branch ' | awk {'print $3'})
        local repo=$(basename $dir)

        branch="\[${_DO_FG_RED}\]${branch}\[${_DO_FG_NORMAL}\]"
        repo="\[${_DO_TX_BOLD}${_DO_FG_CYAN}\]${repo}\[${_DO_FG_NORMAL}${_DO_TX_NORMAL}\]"
        text="${repo}:${branch}"
    else
        # Just prints the current directory.
        text="${dir}$"
    fi


    PS1="
\[${_DO_FG_GREEN}\]➜ ${environment} ${text} \[${_DO_FG_NORMAL}\]"
}


# ==============================================================================
# Plugin Init
# ==============================================================================

function _do_prompt_plugin_init() {
    PROMPT_COMMAND=_do_prompt
}

