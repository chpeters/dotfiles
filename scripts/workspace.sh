#!/bin/sh
# Parallel Rex workspace: editor left (70%), two fish shells right.
set -eu
session=work
reset=false
while [ "$#" -gt 0 ]; do
    case "$1" in
        --reset|reset) reset=true ;;
        --name) shift; [ "$#" -gt 0 ] || { echo 'Missing session name' >&2; exit 2; }; session=$1 ;;
        *) echo 'usage: workspace [--reset] [--name NAME]' >&2; exit 2 ;;
    esac
    shift
done
rex_bin=${REX_BIN_DIR:+$REX_BIN_DIR/rex}
if [ -z "$rex_bin" ]; then rex_bin=$(command -v rex || true); fi
if [ -z "$rex_bin" ]; then rex_bin='/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex'; fi
[ -x "$rex_bin" ] || { echo 'workspace: Rex is not installed' >&2; exit 127; }
for dependency in jq nvim fish; do
    command -v "$dependency" >/dev/null || { echo "workspace: missing $dependency" >&2; exit 127; }
done
sessions=$("$rex_bin" ls --json)
ids=$(printf '%s' "$sessions" | jq -r --arg name "$session" '.sessions[] | select(.label == $name) | .session_id')
count=$(printf '%s' "$sessions" | jq --arg name "$session" '[.sessions[] | select(.label == $name)] | length')
[ "$count" -le 1 ] || { echo "workspace: ambiguous session label: $session" >&2; exit 1; }
if [ "$reset" = true ] && [ -n "$ids" ]; then
    [ "${REX_SESSION:-}" != "$ids" ] || { echo 'workspace: leave this session before resetting it' >&2; exit 1; }
    "$rex_bin" kill "$ids"
    ids=
fi
if [ -z "$ids" ]; then
    ids=$("$rex_bin" new "$session" --cwd "$PWD" --json -- nvim | jq -er '.session_id')
    # Remove only this newly created session if layout construction fails.
    trap '"$rex_bin" kill "$ids" >/dev/null 2>&1 || true' EXIT
    editor=$("$rex_bin" session inspect "$ids" --json | jq -er '.windows[0].focused_block_id')
    right=$("$rex_bin" split -s "$ids" -b "$editor" --split right --ratio 30 --cwd "$PWD" --label shell-top --focus=false --json -- fish | jq -er '.block_ids[0]')
    "$rex_bin" split -s "$ids" -b "$right" --split below --ratio 50 --cwd "$PWD" --label shell-bottom --focus=false -- fish >/dev/null
    "$rex_bin" focus -s "$ids" "$editor"
    trap - EXIT
fi
open -a 'Rex Beta'
# The session exists even if the app has not connected yet.
if ! "$rex_bin" do session.select "session_id=$ids" >/dev/null; then
    echo "Workspace is ready: select '$session' in Rex." >&2
fi
printf '%s\n' "$ids"
