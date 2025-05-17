#!/bin/zsh

# Currently broken!

# TMUX Session Manager UI for Zsh
# Modular, clean, and easy to maintain

# ──────────────────────────────────────────────────────────────
# Draws a centered box with a title
# Usage: draw_box <content_width> <title> <color> <left_padding_prefix_for_centering>
draw_box() {
    local content_width="$1" title_text="$2" color="$3" left_padding_prefix="$4"
    local reset="\033[0m" bold="\033[1m"
    local box_top_content="╔$(printf '═%.0s' $(seq 1 $((content_width - 2))))╗"
    local box_bottom_content="╚$(printf '═%.0s' $(seq 1 $((content_width - 2))))╝"
    local box_side="║"
    local title_len="${#title_text}"
    local pad_total_title=$((content_width - 2 - title_len))
    local pad_left_title=$((pad_total_title / 2))
    local pad_right_title=$((pad_total_title - pad_left_title))
    local pad_left_title_str=$(printf '%*s' "$pad_left_title" "")
    local pad_right_title_str=$(printf '%*s' "$pad_right_title" "")

    printf "%s%b\n" "${left_padding_prefix}" "${color}${box_top_content}${reset}"
    printf "%s%b%s%b%s%b\n" "${left_padding_prefix}" "${color}${box_side}${reset}" "$pad_left_title_str" "${bold}${color}${title_text}${reset}" "$pad_right_title_str" "${color}${box_side}${reset}"
    printf "%s%b\n" "${left_padding_prefix}" "${color}${box_bottom_content}${reset}"
}

# ──────────────────────────────────────────────────────────────
# Main menu function
tmux_session_manager_menu() {
    if [[ -n "$TMUX" || $- != *i* ]] || ! command -v tmux &>/dev/null; then
        if [[ -n "$TMUX" ]]; then return 0; fi
        if [[ $- != *i* ]]; then return 1; fi
        if ! command -v tmux &>/dev/null; then
            echo "Error: tmux command not found. Please install tmux." >&2
            return 1
        fi
    fi

    local fg="\033[38;5;223m"      # #ebdbb2
    local fg4="\033[38;5;246m"     # #a89984
    local yellow="\033[38;5;172m"   # #d79921
    local yellow_bright="\033[38;5;11m" # #fabd2f
    local blue="\033[38;5;110m"     # #83a598
    local aqua_bright="\033[38;5;14m" # #8ec07c
    local green_bright="\033[38;5;10m" # #b8bb26
    local red_bright="\033[38;5;9m"  # #fb4934
    local orange="\033[38;5;166m"   # #d65d0e
    local purple_bright="\033[38;5;13m" # #d3869b
    local dim="\033[2m"
    local reset="\033[0m"
    local bold="\033[1m"
    local icon_session="󰆍"; local icon_quit="󰅚"; local icon_wait="󰔟"
    local ui_content_width=44
    local internal_pad="  " # Two spaces for padding inside the box border

    while true; do
        clear
        
        # --- Horizontal Centering Setup ---
        local term_cols=$(tput cols)
        if ! [[ "$term_cols" =~ ^[0-9]+$ ]] || (( term_cols == 0 )); then term_cols=80; fi
        local total_padding_for_ui_horiz=$((term_cols - ui_content_width))
        local left_padding_cols=$((total_padding_for_ui_horiz / 2))
        if (( left_padding_cols < 0 )); then left_padding_cols=0; fi
        local left_padding_prefix=$(printf '%*s' "$left_padding_cols" "")

        # --- Fix for HR Line Character & Dynamic Generation ---
        local hr_line_char="-" # Using hyphen for max compatibility
        local hr_line=$(printf "%${ui_content_width}s" "" | tr ' ' "$hr_line_char")

        # --- Vertical Centering Setup ---
        local term_lines=$(tput lines)
        if ! [[ "$term_lines" =~ ^[0-9]+$ ]] || (( term_lines == 0 )); then term_lines=24; fi # Fallback height

        # Calculate UI height for current iteration
        local ui_actual_height=0
        ui_actual_height=3 # draw_box
        ui_actual_height=$((ui_actual_height + 1)) # hr_line top

        # Get session list for processing and height calculation
        local sessions_raw=("${(@f)$(tmux list-sessions -F '#{session_name}' 2>/dev/null)}")
        local sessions=()
        local main_session_exists=0
        local main_session_name="main"

        if (( ${sessions_raw[(Ie)$main_session_name]} )); then
            sessions+=("$main_session_name")
            main_session_exists=1
        fi
        for s in "${sessions_raw[@]}"; do
            if [[ "$s" != "$main_session_name" ]]; then sessions+=("$s"); fi
        done
        local session_count=${#sessions}

        if (( session_count > 0 )); then
            ui_actual_height=$((ui_actual_height + 2)) # "Available Sessions:\n" (text + blank line from \n)
            ui_actual_height=$((ui_actual_height + session_count)) # Session list items
            ui_actual_height=$((ui_actual_height + 2)) # "\nPress Enter to attach..." (blank line from \n + text)
        else
            ui_actual_height=$((ui_actual_height + 1)) # "No existing..."
            ui_actual_height=$((ui_actual_height + 1)) # "Press Enter to create..."
        fi

        ui_actual_height=$((ui_actual_height + 1)) # hr_line bottom
        ui_actual_height=$((ui_actual_height + 1)) # "Options:"
        ui_actual_height=$((ui_actual_height + 3)) # 3 option items
        ui_actual_height=$((ui_actual_height + 2)) # "\nChoice:" (blank line from \n + prompt line)
        
        local top_padding_lines=0
        if (( term_lines > ui_actual_height )); then
            top_padding_lines=$(((term_lines - ui_actual_height) / 2))
        fi

        # Apply top padding
        for i in $(seq 1 $top_padding_lines); do echo ""; done
        
        # --- Draw the UI ---
        draw_box "$ui_content_width" "TMUX Session Manager" "$blue" "$left_padding_prefix"
        echo -e "${left_padding_prefix}${fg4}${hr_line}${reset}"

        if (( session_count > 0 )); then
            echo -e "${left_padding_prefix}${internal_pad}${aqua_bright}${icon_session}  ${bold}Available Sessions:${reset}\\n"
            for i in {1..$session_count}; do
                local session_display_name="${sessions[$i]}"
                local index_part="$i)"
                local session_text_part="$session_display_name"
                local default_tag_part=""
                local index_color="${aqua_bright}"; local session_name_color="${fg}"
                if [[ "${sessions[$i]}" == "$main_session_name" ]]; then
                    default_tag_part="${dim}${fg4}(default)${reset}"
                    index_color="${yellow_bright}"; session_name_color="${bold}${fg}"
                fi
                local current_line_str=$(printf "%b%s%b %b%s%b %s" \
                    "${index_color}" "$index_part" "${reset}" \
                    "${session_name_color}" "${session_text_part}" "${reset}" \
                    "$default_tag_part")
                echo -e "${left_padding_prefix}${internal_pad}${current_line_str}"
            done
            echo -e "\\n${left_padding_prefix}${internal_pad}${blue}${icon_wait}  ${fg}Press Enter to attach ${bold}${yellow_bright}${sessions[1]}${reset}"
        else
            echo -e "${left_padding_prefix}${internal_pad}${blue}${icon_wait}  ${fg4}No existing TMUX sessions found${reset}"
            echo -e "${left_padding_prefix}${internal_pad}${blue}${icon_wait}  ${fg}Press Enter to create and attach to '${yellow_bright}${main_session_name}${reset}'"
        fi
        echo -e "${left_padding_prefix}${fg4}${hr_line}${reset}"

        echo -e "${left_padding_prefix}${internal_pad}${green_bright}${bold}Options:${reset}"
        printf "%s%s%b%-8s%b %b- Select session%b\n" "${left_padding_prefix}" "${internal_pad}" "${aqua_bright}" "[number]" "${reset}" "${dim}" "${reset}"
        printf "%s%s%b%-8s%b %b- New session%b\n" "${left_padding_prefix}" "${internal_pad}" "${green_bright}" "[n]" "${reset}" "${dim}" "${reset}"
        printf "%s%s%b%-8s%b %b- Quit%b\n" "${left_padding_prefix}" "${internal_pad}" "${red_bright}" "[q]" "${reset}" "${dim}" "${reset}"

        echo -ne "\n${left_padding_prefix}${internal_pad}${yellow}${bold}Choice:${reset} "
        read choice

        # --- Action Handling (Error messages may need adjustment if they also need full centering) ---
        # Note: After a 'clear' in an action, the vertical padding will apply to the error message IF it's the only thing printed before sleep.
        # For messages like "Invalid choice" which don't clear, they will appear relative to the main UI block.
        case "$choice" in
            "" | 1 )
                clear
                # Minimal output after clear for attach/new session errors ensures they benefit from some vertical padding too.
                # For true vertical centering of just the error, height calc would need to be just for the error message.
                # For now, they will appear near the top after a clear, but horizontally centered.
                local target_session_name
                if (( session_count > 0 )); then
                    target_session_name="${sessions[1]}"
                    if tmux attach-session -t "$target_session_name" 2>/dev/null; then break; else
                        for i in $(seq 1 $(((term_lines - 3) / 2))); do echo ""; done # Quick vertical pad for error
                        echo -e "${left_padding_prefix}${internal_pad}${red_bright}${icon_quit}  ${orange}Attach failed! Session '${target_session_name}' may have been removed.${reset}"
                    fi
                else
                    target_session_name="$main_session_name"
                    if tmux new-session -A -s "$target_session_name" 2>/dev/null; then break; else
                        for i in $(seq 1 $(((term_lines - 3) / 2))); do echo ""; done # Quick vertical pad for error
                        echo -e "${left_padding_prefix}${internal_pad}${red_bright}${icon_quit}  ${orange}Failed to create session '${target_session_name}'!${reset}"
                    fi
                fi
                sleep 2
                ;;
            n|N)
                clear
                # The "Create New Session" UI will also be vertically padded due to the loop structure
                # If we want it perfectly centered alone, we'd recalculate its own height (box + prompt = ~5 lines)
                # and apply vertical padding just for it.
                # For simplicity, let it use the main loop's next iteration padding or a quick one:
                local create_session_ui_height=5 # draw_box (3) + prompt (2 for \n and line)
                for i in $(seq 1 $(((term_lines - create_session_ui_height) / 2))); do echo ""; done

                draw_box "$ui_content_width" "Create New Session" "$blue" "$left_padding_prefix"
                echo -ne "${left_padding_prefix}${internal_pad}${aqua_bright}Session name ${reset}${dim}(${yellow_bright}default: ${main_session_name}${dim}): ${reset}"
                read session_name_input
                local sanitized_session_name=$(echo "$session_name_input" | tr -s ' ' '_' | sed 's/[^a-zA-Z0-9_.-]//g')
                local final_new_session_name="${sanitized_session_name:-$main_session_name}"
                if tmux new-session -A -s "$final_new_session_name" 2>/dev/null; then break; else
                    # Error message for this screen
                    clear # Clear the "Create New Session" box
                    for i in $(seq 1 $(((term_lines - 3) / 2))); do echo ""; done # Quick vertical pad for error
                    echo -e "${left_padding_prefix}${internal_pad}${red_bright}${icon_quit}  ${orange}Failed to create session '${final_new_session_name}'! Invalid name or server problem.${reset}"
                    sleep 2
                fi
                ;;
            q|Q) clear; break ;;
            *)
                if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= session_count )); then
                    clear
                    local target_session_name="${sessions[choice]}"
                    if tmux attach-session -t "$target_session_name" 2>/dev/null; then break; else
                        for i in $(seq 1 $(((term_lines - 3) / 2))); do echo ""; done # Quick vertical pad for error
                        echo -e "${left_padding_prefix}${internal_pad}${red_bright}${icon_quit}  ${orange}Attach failed! Session '${target_session_name}' may have been removed.${reset}"
                        sleep 2
                    fi
                else
                    # "Invalid choice" prints on the current screen.
                    # The previous full UI is still there. This message will appear below it.
                    # The 'clear' at the start of the loop will handle full redraw.
                    echo -e "\n${left_padding_prefix}${internal_pad}${red_bright}${icon_quit}  ${purple_bright}Invalid choice: ${choice}! Please try again.${reset}"
                    sleep 1
                fi
                ;;
        esac
    done
}

tmux_session_manager_menu

