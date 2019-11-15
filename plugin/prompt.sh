
_do_log_level_warn "prompt"


_DO_PROMPT_DIR=""
_DO_PROMPT_UPDATE_FORCED="yes"


# ==============================================================================
# Plugin Init
# ==============================================================================

function _do_prompt_plugin_init() {
    PROMPT_COMMAND=_do_prompt

    # If the environment updated, update the prompt.
    _do_hook_after "_do_env_login" "_do_prompt_force_update"
}



# This function is called whenever the current directory changed. 
# 
function _do_prompt() {
    local dir=$(pwd)

    if [ "${_DO_PROMPT_UPDATE_FORCED}" == "yes" ]; then 
        _DO_PROMPT_UPDATE_FORCED="no"
    else 
        if [ "${dir}" == "$_DO_PROMPT_DIR" ]; then 
            return
        fi 
    fi 

    # Current directory has been changed
    _DO_PROMPT_DIR="${dir}"

    # Triggers hook for other plugin to process
    _do_hook_call "_do_prompt" $dir

    local environment=""
    if [ ! -z "${DO_ENV}" ]; then 
        environment="\[${_DO_TX_NORMAL} ${_DO_TX_BOLD}${_DO_FG_ENVIRONMENT}${_DO_TX_REVERSED}\] ${DO_ENV} \[${_DO_TX_NORMAL}\]"
    fi

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


function _do_prompt_force_update() {
    _do_log_debug "prompt" "force update"
    
    _DO_PROMPT_UPDATE_FORCED="yes"
    _do_prompt
}
