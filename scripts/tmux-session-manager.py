#!/usr/bin/env python3
import subprocess
import sys
import os
import re

MAIN_SESSION = "main"

def get_tmux_sessions():
    """Returns a list of tmux session names (strings)."""
    try:
        output = subprocess.check_output(
            ["tmux", "list-sessions", "-F", "#{session_name}"],
            stderr=subprocess.DEVNULL
        )
        return output.decode().splitlines()
    except subprocess.CalledProcessError:
        return []

def clear_screen():
    """Clear the terminal screen."""
    print("\033c", end="")

def attach_tmux(session):
    """Attach to an existing tmux session."""
    os.execvp("tmux", ["tmux", "attach", "-t", session])

def new_tmux(session):
    """Create (or attach to) a new tmux session. Name first window after session."""
    os.execvp("tmux", ["tmux", "new-session", "-A", "-s", session, "-n", session])

def kill_tmux(session):
    """Kill a tmux session."""
    subprocess.call(["tmux", "kill-session", "-t", session])

def print_header():
    """Print the header/title of the manager."""
    print("=" * 45)
    print("            TMUX Session Manager")
    print("=" * 45)
    print()  # Add spacing after the header

def print_sessions(sessions):
    """Print the list of sessions, highlighting MAIN_SESSION as default."""
    if sessions:
        print("Available Sessions:")
        for idx, name in enumerate(sessions, 1):
            suffix = " (default)" if name == MAIN_SESSION else ""
            print(f"  {idx}) {name}{suffix}")
        print()
        print(f"Press Enter to attach '{sessions[0]}'")
    else:
        print("No existing tmux sessions found.")
        print(f"Press Enter to create and attach to '{MAIN_SESSION}'")
    print()

def print_options():
    """Print the menu options."""
    print("Options:")
    print(" [number]   - Attach session")
    print(" [n]        - New session")
    print(" [d]        - Delete session")
    print(" [q]        - Quit")
    print()

def prompt_choice():
    """Prompt the user for a menu choice."""
    return input("Choice: ").strip()

def prompt_new_session():
    """Prompt the user for a new session name."""
    print()
    session_name = input(f"Session name (default={MAIN_SESSION}): ").strip()
    print()
    # Sanitize: allow only alphanumeric and underscore
    session_name = re.sub(r'[^a-zA-Z0-9_]', '_', session_name)
    if not session_name:
        session_name = MAIN_SESSION
    return session_name

def prompt_delete_session(sessions):
    """Prompt the user to select a session to delete."""
    print()
    if not sessions:
        print("No sessions to delete.\n")
        input("Press Enter to continue...")
        print()
        return None
    print("Which session to delete?")
    for idx, name in enumerate(sessions, 1):
        print(f"  {idx}) {name}")
    print()
    del_choice = input("Session number to delete: ").strip()
    print()
    if del_choice.isdigit():
        del_idx = int(del_choice) - 1
        if 0 <= del_idx < len(sessions):
            session_to_kill = sessions[del_idx]
            confirm = input(f"Are you sure you want to delete session '{session_to_kill}'? (y/N): ").strip().lower()
            print()
            if confirm == "y":
                return session_to_kill
            else:
                print("Delete canceled.\n")
                input("Press Enter to continue...")
                print()
        else:
            print("Invalid session number.\n")
            input("Press Enter to continue...")
            print()
    else:
        print("Not a valid number.\n")
        input("Press Enter to continue...")
        print()
    return None

def main():
    if os.environ.get("TMUX"):
        print("Already inside tmux. Exit this tmux client to use the manager.")
        sys.exit(0)
    if subprocess.call("command -v tmux >/dev/null", shell=True) != 0:
        print("tmux not installed. Install it first.")
        sys.exit(1)

    while True:
        clear_screen()
        print_header()

        # Build session list: main session first, others after
        sessions_raw = get_tmux_sessions()
        sessions = [s for s in sessions_raw if s == MAIN_SESSION] + \
                   [s for s in sessions_raw if s != MAIN_SESSION]

        print_sessions(sessions)
        print_options()
        choice = prompt_choice()
        print()

        if choice == "":
            if sessions:
                attach_tmux(sessions[0])
            else:
                new_tmux(MAIN_SESSION)
            break

        elif choice == "1":
            if sessions:
                attach_tmux(sessions[0])
            else:
                new_tmux(MAIN_SESSION)
            break

        elif choice.lower() == "n":
            session_name = prompt_new_session()
            new_tmux(session_name)
            break

        elif choice.lower() == "d":
            session_to_delete = prompt_delete_session(sessions)
            if session_to_delete:
                kill_tmux(session_to_delete)
                print(f"Session '{session_to_delete}' deleted.\n")
                input("Press Enter to continue...")
                print()

        elif choice.lower() == "q":
            clear_screen()
            break

        elif choice.isdigit() and sessions and 1 <= int(choice) <= len(sessions):
            attach_tmux(sessions[int(choice)-1])
            break

        else:
            print("Invalid choice!\n")
            input("Press Enter to continue...")
            print()

if __name__ == "__main__":
    main()
