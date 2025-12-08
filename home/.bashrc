#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Run neofetch with centered image
neofetch --kitty /home/nova/Pictures/Pintrest/wire.jpg --size 200px --gap 10 --xoffset 5 --yoffset 2  

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

# Import colors from pywal
source ~/.cache/wal/colors.sh

# Function to convert hex to RGB for prompt
hex_to_rgb() {
    local hex=${1#\#}
    printf "%d;%d;%d" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

# Color definitions using pywal colors
RESET='\[\e[0m\]'
BOLD='\[\e[1m\]'
WHITE='\[\e[38;5;255m\]'

# Convert pywal colors to RGB for true color support
C1=$(hex_to_rgb "$color1")
C4=$(hex_to_rgb "$color4")
C5=$(hex_to_rgb "$color5")
C6=$(hex_to_rgb "$color6")

# Custom prompt with rectangle around username
PS1="${BOLD}\[\e[38;2;${C4}m\]╭─\[\e[48;2;${C1}m\]${WHITE} \u \[\e[49m\]\[\e[38;2;${C4}m\]─[\[\e[38;2;${C5}m\]\w\[\e[38;2;${C4}m\]]\n\[\e[38;2;${C4}m\]╰─\[\e[38;2;${C6}m\]❯${RESET} "

# Alternative prompt styles (comment/uncomment to switch):

# Style 2: Boxed with host
# PS1="${BOLD}${CYAN}┌─${BG_BLUE}${WHITE} \u@\h ${BG_RESET}${CYAN}─[${PURPLE}\w${CYAN}]\n${CYAN}└─${MAGENTA}❯${RESET} "

# Style 3: Minimal box
# PS1="${BOLD}${BG_BLUE}${WHITE} \u ${BG_RESET} ${PURPLE}\W ${MAGENTA}❯${RESET} "

# Style 4: Double border
# PS1="${BOLD}${CYAN}╔═${BG_BLUE}${WHITE} \u ${BG_RESET}${CYAN}═[${PURPLE}\w${CYAN}]\n${CYAN}╚═${MAGENTA}❯${RESET} "
