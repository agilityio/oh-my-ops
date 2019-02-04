# See: https://www.howtogeek.com/307701/how-to-customize-and-colorize-your-bash-prompt/
# for how the bash prompt is configured.
# Here are the values for background colors:

#   Black background: 40
#   Blue background: 44
#   Cyan background: 46
#   Green background: 42
#   Purple background: 45
#   Red background: 41
#   White background: 47
#   Yellow background: 43
BG_BLACK="\033[40m"
BG_BLUE="\033[44m"
BG_CYAN="\033[46m"
BG_GREEN="\033[42m"
BG_PURPLE="\033[45m"
BG_RED="\033[41m"
BG_WHITE="\033[47m"
BG_YELLOW="\033[43m"

# Text Colors:
#   Black: 30
#   Blue: 34
#   Cyan: 37
#   Green: 32
#   Purple: 35
#   Red: 31
#   White: 37
#   Yellow: 33
FG_BLACK="\033[00m"
FG_BLUE="\033[34m"
FG_CYAN="\033[36m"
FG_GREEN="\033[32m"
FG_PURPLE="\033[35m"
FG_RED="\033[31m"
FG_WHITE="\033[37m"
FG_YELLOW="\033[33m"

# Text Attributes:
#   Normal Text: 0
#   Bold or Light Text: 1 (It depends on the terminal emulator.)
#   Dim Text: 2
#   Underlined Text: 4
#   Blinking Text: 5 (This does not work in most terminal emulators.)
#   Reversed Text: 7 (This inverts the foreground and background colors,
#           so you’ll see black text on a white background if the current text
#           is white text on a black background.)
#   Hidden Text: 8
TX_NORMAL="\033[0m"
TX_BOLD="\033[1m"
TX_DIM="\033[2m"
TX_UNDERLINE="\033[4m"
TX_BLINK="\033[5m"
TX_REVERSED="\033[7m"
TX_HIDDEN="\033[8m"

FG_NORMAL="${FG_BLACK}"

# Highlight the environment if not local.
# if [ "${ENVIRONMENT}" == "local" ]; then
    export FG_ENVIRONMENT=${FG_GREEN}
# else
    # export FG_ENVIRONMENT=${FG_RED}
# fi

