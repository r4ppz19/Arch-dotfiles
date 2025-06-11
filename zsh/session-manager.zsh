# TMUX Session Manager UI

# ──────────────────────────────────────────────────────────────
# Draws a centered box with a title
# Usage: draw_box <width> <title> <color>
draw_box() {
  local box_width="$1" title_text="$2" color="$3"
  local reset="\033[0m" bold="\033[1m"
  local box_top="╔$(printf '═%.0s' $(seq 1 $((box_width-2))))╗"
  local box_bottom="╚$(printf '═%.0s' $(seq 1 $((box_width-2))))╝"
  local box_side="║"
  local title_len="${#title_text}"
  local pad_total=$((box_width - 2 - title_len))
  local pad_left=$((pad_total / 2))
  local pad_right=$((pad_total - pad_left))
  local pad_left_str=$(printf '%*s' "$pad_left" "")
  local pad_right_str=$(printf '%*s' "$pad_right" "")
  printf "%b\n" "${color}${box_top}${reset}"
  printf "%b%b%b%b%b\n" "${color}${box_side}${reset}" "$pad_left_str" "${bold}${color}${title_text}${reset}" "$pad_right_str" "${color}${box_side}${reset}"
  printf "%b\n" "${color}${box_bottom}${reset}"
}

# ──────────────────────────────────────────────────────────────
# Main menu function
tmux_session_manager_menu() {
  # Only run if not in TMUX and in an interactive shell
  if [[ -n "$TMUX" || $- != *i* ]] || ! command -v tmux &>/dev/null; then
    return
  fi

  # Gruvbox
  local fg="\033[38;5;223m"         # #ebdbb2
  local fg4="\033[38;5;246m"        # #a89984
  local yellow="\033[38;5;172m"     # #d79921
  local yellow_bright="\033[38;5;11m" # #fabd2f
  local blue="\033[38;5;110m"       # #83a598
  local aqua_bright="\033[38;5;14m" # #8ec07c
  local green_bright="\033[38;5;10m" # #b8bb26
  local red_bright="\033[38;5;9m"   # #fb4934
  local orange="\033[38;5;166m"     # #d65d0e
  local purple_bright="\033[38;5;13m" # #d3869b
  local dim="\033[2m"
  local reset="\033[0m"
  local bold="\033[1m"

  # Icons
  local icon_session="󰆍"
  local icon_quit="󰅚"
  local icon_wait="󰔟"

  while true; do
    clear
    draw_box 44 "TMUX Session Manager" "$blue"

    # List sessions
    local sessions_raw=(${(f)"$(tmux list-sessions -F '#{session_name}' 2>/dev/null)"})
    local sessions=()
    local main_session_exists=0
    local main_session_name="main" # Define main session name for easier changes

    # Check if main session exists and add it first
    for s in "${sessions_raw[@]}"; do
      if [[ "$s" == "$main_session_name" ]]; then
        sessions+=("$s")
        main_session_exists=1
        break
      fi
    done

    # Add other sessions, excluding main if already added
    for s in "${sessions_raw[@]}"; do
      if [[ "$s" != "$main_session_name" ]]; then
        sessions+=("$s")
      fi
    done

    local session_count=${#sessions}
    local choice

    echo -e "${fg4}────────────────────────────────────────────${reset}"
    if (( session_count > 0 )); then
      echo -e "${aqua_bright}${icon_session}  ${bold}Available Sessions:${reset}\\n"
      for i in {1..$session_count}; do
        if [[ "${sessions[$i]}" == "$main_session_name" ]]; then
          echo -e "  ${yellow_bright}$i)${reset} ${bold}${fg}${sessions[$i]}${reset} ${dim}${fg4}(default)${reset}"
        else
          echo -e "  ${aqua_bright}$i)${reset} ${fg}${sessions[$i]}${reset}"
        fi
      done
      # Default attach message always refers to the first session in the list (which is 'main' if it exists)
      echo -e "\\n${blue}${icon_wait}  ${fg}Press Enter to attach ${bold}${yellow_bright}${sessions[1]}${reset}"
    else
      echo -e "${blue}${icon_wait}  ${fg4}No existing TMUX sessions found${reset}"
      echo -e "${blue}${icon_wait}  ${fg}Press Enter to create and attach to '${yellow_bright}${main_session_name}${reset}'"
    fi
    echo -e "${fg4}────────────────────────────────────────────${reset}"

    # Options
    echo -e "${green_bright}${bold}Options:${reset}"
    printf "  ${aqua_bright}%-8s${reset} ${dim}- Select session${reset}\n" "[number]"
    printf "  ${green_bright}%-8s${reset} ${dim}- New session${reset}\n" "[n]"
    printf "  ${red_bright}%-8s${reset} ${dim}- Quit${reset}\n" "[q]"

    echo -ne "\n${yellow}${bold}Choice:${reset} "
    read choice

    case "$choice" in
      "") # Enter key pressed
        clear
        if (( session_count > 0 )); then
          # Attach to the first session in the list (main if exists, otherwise the first available)
          tmux attach -t "${sessions[1]}" 2>/dev/null && break
          echo -e "\\n${red_bright}${icon_quit}  ${orange}Attach failed! Session may have been removed${reset}"
        else
          # No sessions exist, create and attach to main_session_name
          tmux new-session -A -s "$main_session_name" 2>/dev/null && break
          echo -e "\\n${red_bright}${icon_quit}  ${orange}Failed to create session '${main_session_name}'!${reset}"
        fi
        sleep 1
        ;;
      1) # Number 1 pressed
        clear
        if (( session_count > 0 )); then
          # Attach to the first session in the list
          tmux attach -t "${sessions[1]}" 2>/dev/null && break
          echo -e "\\n${red_bright}${icon_quit}  ${orange}Attach failed! Session may have been removed${reset}"
        else
          # No sessions, create main_session_name (same as Enter)
          tmux new-session -A -s "$main_session_name" 2>/dev/null && break
          echo -e "\\n${red_bright}${icon_quit}  ${orange}Failed to create session '${main_session_name}'!${reset}"
        fi
        sleep 1
        ;;
      n|N)
        clear
        draw_box 44 "Create New Session" "$blue"
        echo -ne "${aqua_bright}Session name${reset} ${dim}(${yellow_bright}default=${main_session_name}${dim}): ${reset}"
        read session_name
        session_name="${session_name//[^a-zA-Z0-9_]/_}"
        # Use main_session_name as default if no name is entered
        tmux new-session -A -s "${session_name:-$main_session_name}" 2>/dev/null && break
        echo -e "\\n${red_bright}${icon_quit}  ${orange}Failed to create session! Invalid name or server problem${reset}"
        sleep 1
        ;;
      q|Q)
        clear
        break
        ;;
      *)
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= session_count )); then
          clear
          # Attach to the selected session by its index in the 'sessions' array
          tmux attach -t "${sessions[choice]}" 2>/dev/null && break
          echo -e "\\n${red_bright}${icon_quit}  ${orange}Attach failed! Session may have been removed${reset}"
        else
          echo -e "\\n${red_bright}${icon_quit}  ${purple_bright}Invalid choice!${reset}"
        fi
        sleep 1
        ;;
    esac
  done
}

# ──────────────────────────────────────────────────────────────
# Run the menu
tmux_session_manager_menu 
