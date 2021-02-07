#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SESSION_NAME="$1"

source "$CURRENT_DIR/helpers.sh"

dismiss_session_list_page_from_view() {
	tmux send-keys C-c
}

session_name_not_provided() {
	[ -z "$SESSION_NAME" ]
}

main() {
	if session_name_not_provided; then
		dismiss_session_list_page_from_view
		exit 0
	fi
	if session_exists_grep; then
		dismiss_session_list_page_from_view
		local session_found=$(tmux list-sessions | sed 's/:.*//' | grep "$SESSION_NAME"| head -n 1)
		tmux switch-client -t "$session_found"
	else
		# goto command prompt again
		tmux command -p session: "run '$CURRENT_DIR/switch_or_loop.sh \"%1\"'"
	fi
}
main
