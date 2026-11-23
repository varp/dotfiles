#!/usr/bin/env bash
# Merges claude/settings.hooks.json into ~/.claude/settings.json.
#
# settings.json is not symlinked: Claude Code and tools (plugins, orca, rex)
# rewrite it, which would replace the link or leak machine state into git.
# The merge is idempotent: an existing entry that runs one of the fragment's
# commands is replaced, never duplicated; everything else is kept.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
frag="$here/settings.hooks.json"
dst="${DST_BASE_DIR:-$HOME}/.claude/settings.json"

command -v jq >/dev/null || { echo "jq is required: brew install jq" >&2; exit 1; }
mkdir -p "$(dirname "$dst")"
existed=true
[ -f "$dst" ] || { echo '{}' > "$dst"; existed=false; }

tmp="$(mktemp "$dst.XXXXXX")"
jq --slurpfile frag "$frag" '
  $frag[0].hooks as $fh
  | .hooks = (.hooks // {})
  | reduce ($fh | keys[]) as $ev (.;
      ([$fh[$ev][].hooks[].command]) as $cmds
      | .hooks[$ev] = (
          ((.hooks[$ev] // [])
            | map(select(any(.hooks[]?.command; . as $c | $cmds | index($c) != null) | not)))
          + $fh[$ev]))
' "$dst" > "$tmp"

if cmp -s "$tmp" "$dst"; then
  rm -f "$tmp"
  echo "claude: $dst already up to date"
else
  if $existed; then
    cp -f "$dst" "$dst.bak"
    note=" (previous copy: $dst.bak)"
  fi
  mv -f "$tmp" "$dst"
  echo "claude: merged hooks into $dst${note:-}"
fi
