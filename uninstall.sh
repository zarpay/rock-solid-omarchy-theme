#!/bin/bash
# Remove the ZAR theme and everything install.sh placed. Restores the stock
# bar widgets and the previous menu extension if one was backed up.
set -euo pipefail
PLUGIN_DIR="$HOME/.config/omarchy/plugins"
SHELL_JSON="$HOME/.config/omarchy/shell.json"
EXT="$HOME/.config/omarchy/extensions/omarchy-menu.jsonc"

if [[ -f $SHELL_JSON ]]; then
  map='{}'
  for m in "$PLUGIN_DIR"/zar.*/manifest.json; do
    [[ -f $m ]] || continue
    map=$(jq -c --arg k "$(jq -r .id "$m")" --arg v "$(jq -r '.omarchy.clonedFrom // empty' "$m")" '. + {($k):$v}' <<<"$map")
  done
  tmp=$(mktemp)
  jq --argjson map "$map" '
    if (.bar.layout|type)=="object" then
      .bar.layout |= with_entries(.value |= map(if (.id? and $map[.id]) then .id = $map[.id] else . end))
    else . end' "$SHELL_JSON" > "$tmp" && mv "$tmp" "$SHELL_JSON"
fi
rm -rf "$PLUGIN_DIR"/zar.*
if grep -q "ZAR brand glyphs" "$EXT" 2>/dev/null; then
  last=$(ls -t "$EXT".bak.* 2>/dev/null | head -1 || true)
  if [[ -n $last ]]; then mv "$last" "$EXT"; else rm -f "$EXT"; fi
fi
[[ $(omarchy-theme-current 2>/dev/null) == "Zar" ]] && omarchy-theme-set tokyo-night
rm -rf "$HOME/.config/omarchy/themes/zar" "$HOME/.local/share/icons/ZAR" "$HOME/.local/share/fonts/zar"
fc-cache -f >/dev/null
gsettings reset org.gnome.desktop.interface font-name 2>/dev/null || true
omarchy restart shell >/dev/null 2>&1 || true
echo "ZAR theme removed."
