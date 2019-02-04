
function _do_prompt() {
    local dir=$(pwd)
    local environment="\[${TX_NORMAL} ${TX_BOLD}${FG_ENVIRONMENT}${TX_REVERSED}\] ${ENVIRONMENT} \[${TX_NORMAL}\]"

    local text
    if [ -d ".git" ]; then
        local branch=$(git status | grep 'On branch ' | awk {'print $3'})
        local repo=$(basename $dir)

        branch="\[${FG_RED}\]${branch}\[${FG_NORMAL}\]"
        repo="\[${TX_BOLD}${FG_CYAN}\]${repo}\[${FG_NORMAL}${TX_NORMAL}\]"
        text="${repo}:${branch}"
    else
        # Just prints the current directory.
        text="${dir}$"
    fi

    PS1="
\[${FG_GREEN}\]➜ ${environment} ${text} \[${FG_NORMAL}\]"
}

function _do_prompt_init() {
    PROMPT_COMMAND=_do_prompt
}

