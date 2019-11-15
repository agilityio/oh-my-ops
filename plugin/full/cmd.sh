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

        local sub_plugin
        local sub_cmd

        for sub_plugin in $(_do_repo_plugin_list "${sub_repo}"); do 
            if [ "${sub_plugin}" == 'full' ]; then 
                # Ignore full command.
                continue
            fi 

            for sub_cmd in $(_do_repo_plugin_cmd_list "${sub_repo}" "${sub_plugin}"); do 

                if [ "${sub_cmd}" == "${cmd}" ] || [[ "${sub_cmd}" == "${cmd}:"* ]]; then 
                    _do_log_debug 'full' "Run command: ${sub_repo}-${sub_plugin}-${sub_cmd}, ${sub_dir}"

                    # Triggers the plugin command handler.
                    local sub_cmd_d=$(_do_string_to_dash "${sub_cmd}")
                    local sub_plugin_d=$(_do_string_to_dash "${sub_plugin}")
                    do-${sub_repo}-${sub_plugin_d}-${sub_cmd_d}
                fi
            done
        done


    done <<< $(_do_repo_list "${dir}")


    return ${err}
}
