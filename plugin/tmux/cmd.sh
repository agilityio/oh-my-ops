
# This function runs tmux section for the given repository.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#     cmd is always "start".
#
# It is important to note that, if the tmux have been run before,
# this will just reopen that session instead of running the new one.
#
function _do_tmux_repo_cmd_start() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  if ! _do_tmux_file_exists "${dir}"; then
    return
  fi

  _do_print_header_1 "Runs tmux for $repo"

  if tmux attach-session -t "$repo" &>/dev/null; then
    # Successfully attach to the previous session. Stop!
    return
  fi

  # Sets to the default config file.
  local config_file="$dir/.tmux"

  if [ ! -f "$config_file" ]; then
    _do_log_error "tmux" "Error: $config_file not found!"
    return 1
  fi

  # Internal Field Separator. As man bash says, it. is used for word
  # splitting after expansion and to split lines into words with the
  # read builtin command.
  local IFS=''

  # Creates a new window session
  tmux new-session -d -s "${repo}" -x 2000 -y 2000
  tmux select-layout "tiled"

  # Show tmux status
  _do_tmux_set_option pane-border-status bottom
  _do_tmux_set_option pane-border-bg colour235
  _do_tmux_set_option pane-border-fg colour238
  _do_tmux_set_option pane-active-border-bg colour236
  _do_tmux_set_option pane-active-border-fg colour51

  # Sets the status title
  _do_tmux_set_option pane-border-format '#P: #(cd #{pane_current_path}; git rev-parse --show-toplevel | xargs basename)'

  # Makes the status update more often.
  _do_tmux_set_option status-interval 5
  _do_tmux_send_activate_cmd

  # Parse all lines in the layout file
  # shellcheck disable=SC2002
  # shellcheck disable=SC2162
  cat "$config_file" | while read line; do
    # Reads in and clean up the line. Notes that line start with `#`
    # will be removed. This will also trim the leading and trailing spaces.
    line=$(echo "$line" | sed -e 's/#.*$//g' -e 's/[[:blank:]]*$//' -e 's/^[[:blank:]]*//')

    # The line is empty. Move on.
    [ -z "$line" ] && continue

    # ------- Layout Parsing ------
    if [[ ${line} == "--"* ]]; then
      cmd="--"
      args=""
    else
      local pattern="^\(-[[:alnum:]]*\)[[:blank:]]*\(.*\)"
      local cmd=
      # shellcheck disable=SC2001
      cmd=$(echo "$line" | sed -e "s/${pattern}/\1/")

      local args=
      # shellcheck disable=SC2001
      args=$(echo "$line" | sed -e "s/${pattern}/\2/")
    fi

    case $cmd in
    "--")
      tmux split-window -h
      tmux select-layout "tiled"
      _do_tmux_send_activate_cmd
      ;;

    "-sleep")
      sleep "$args"
      ;;

    *)
      # Sends the original line to tmux panel.
      _do_tmux_send_keys "$line"
      ;;
    esac
  done

  # Loads up the session
  tmux attach-session
}


# This util will kill the tmux session for a repository.
# Arguments:
#   1-3. dir, repo, cmd: Common repo command arguments.
#     cmd is always "stop".
#
function _do_tmux_repo_cmd_stop() {
  local dir=${1?'dir arg required'}
  local repo=${2?'repo arg required'}
  shift 3

  if ! _do_tmux_file_exists "${dir}"; then
    return
  fi

  _do_print_header_1 "Stops tmux for $repo"

  tmux kill-session -t "$repo" &>/dev/null

  return 0
}

# This util function send any commands to the top tmux session / windows
function _do_tmux_set_option() {
  # shellcheck disable=SC2068
  tmux set-option $@
}


# This util function send any commands to the top tmux session / windows
function _do_tmux_send_keys() {
  tmux send-keys "$@" "C-m"
}


# This util function send devops activate commands to the top
# tmux session/windows
#
function _do_tmux_send_activate_cmd() {
  _do_tmux_send_keys "bash"

  # Insides a tmux pane, activates the oh-my-ops frameworks
  _do_tmux_send_keys "source ${DO_ACTIVATE_FILE} --quick $ENVIRONMENT"

  # Clears screen
  _do_tmux_send_keys "clear"
}

# If the specified repository has a file ".tmux", tmux is enabled for
# the repository.
#
function _do_tmux_file_exists() {
  local dir=$1

  [ -f "${dir}/.tmux" ] || return 1
}
