#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Run neofetch with centered image
fastfetch
# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias dotfiles='/usr/bin/git --git-dir=/home/nova/.dotfiles/ --work-tree=/home/nova'

# Environment variables
export XCURSOR_THEME=breeze_cursors
export XCURSOR_SIZE=24
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export HYPRSHOT_DIR="/home/nova/Pictures/Screenshots"


# Function to convert hex to RGB for prompt
hex_to_rgb() {
  local hex=${1#\#}
  printf "%d;%d;%d" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

RESET='\[\e[0m\]'
BOLD='\[\e[1m\]'
WHITE='\[\e[38;5;255m\]'

C1=$(hex_to_rgb "$color1")
C4=$(hex_to_rgb "$color4")
C5=$(hex_to_rgb "$color5")
C6=$(hex_to_rgb "$color6")

eval "$(starship init bash)"
