#! /usr/bin/env bash

set -euo pipefail

split_window_into_n_panes() {
    local -r window_name="$1"
    local -r num_panes="$2"
    for ((i = 0; i < "$num_panes" - 1; ++i)); do
        tmux split-window -t "$window_name" -v -p 99
    done
    tmux select-layout -t "$window_name" even-vertical
}

main() {
    # http://stackoverflow.com/a/13864829/3187068
    if [[ -z ${TMUX+dummy} ]]; then
        echo "ERROR: you must run this script while in tmux."
        return 1
    fi

    local -r num_servers=3

    # Proxies.
    tmux new-window -n proxies
    split_window_into_n_panes proxies "$num_servers"

    mkdir -p proxy_logs
    rm -rf proxy_logs/*
    for ((i = 0; i < "$num_servers"; ++i)); do
       local cmd="../../libevent_paxos/target/server.out \
                      -n $i \
                      -r \
                      -m s \
                      -c nodes.local.cfg \
                      -l ./proxy_logs"
        tmux send-keys -t "proxies.$i" "$cmd" C-m
    done
    tmux set-window-option -t proxies synchronize-panes on

    # Servers.
    tmux new-window -n servers
    split_window_into_n_panes servers "$num_servers"
    for ((i = 0; i < "$num_servers"; ++i)); do
        local cmd="../../xtern/scripts/wrap-xtern.sh python server.py 700$i"
        tmux send-keys -t "servers.$i" "$cmd" C-m
    done
    tmux set-window-option -t servers synchronize-panes on
}

main
