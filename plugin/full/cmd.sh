function _do_full_repo_cmd() {
    local err=0
    local dir=${1?'dir arg is required'}
    local repo=${2?'repo arg required'}
    local cmd=${3?'arg command is required'}
    shift 3

    _do_log_debug 'full' "do '${cmd}' full on ${repo}, at: ${dir}"

    # Reads out the repository line by line.
    while read -r sub; do 
        # For each line, convert two the array of 2 parts.
        # The first one should be the directory dir, and the second 
        # should be the directory name.
        local parts=( ${sub} )

        local sub_dir=${parts[0]}
        local sub_repo=${parts[1]}

        if [ "${repo}" == "${sub_repo}" ]; then 
            # ignore itself.
            continue
        fi 

        local sub_plugin
        local sub_cmd

        for sub_plugin in $(_do_repo_plugin_list "${sub_repo}"); do 
            for sub_cmd in $(_do_repo_plugin_cmd_list "${sub_repo}" "${sub_plugin}"); do 

                if [ "${cmd}" != "${sub_cmd}" ]; then 
                    # Ignore
                    continue
                fi 

                _do_log_debug 'full' "Run command: ${sub_repo}-${sub_plugin}-${sub_cmd}, ${sub_dir}"

                # Triggers the plugin command handler.
                do-${sub_repo}-${sub_plugin}-${sub_cmd}
            done
        done


    done <<< $(_do_repo_list "${dir}")

    return ${err}
}
