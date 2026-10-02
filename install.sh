#!/bin/bash
# ZAR theme for Omarchy — installs everything: theme, icon theme, glyph font,
# menu glyphs, branded bar widgets. Safe to re-run; re-running updates in place.
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SLUG=zar
THEME_DIR="$HOME/.config/omarchy/themes/$SLUG"
ICON_DIR="$HOME/.local/share/icons/ZAR"
FONT_DIR="$HOME/.local/share/fonts/zar"
PLUGIN_DIR="$HOME/.config/omarchy/plugins"
EXT_DIR="$HOME/.config/omarchy/extensions"
SHELL_JSON="$HOME/.config/omarchy/shell.json"
STAMP=$(date +%Y%m%d-%H%M%S)

say() { printf '\e[33m›\e[0m %s\n' "$*"; }
need() { command -v "$1" >/dev/null || { echo "missing: $1" >&2; exit 1; }; }
need rsync; need jq; need omarchy-theme-set; need fc-cache

say "Theme → $THEME_DIR"
mkdir -p "$THEME_DIR"
rsync -a --delete --exclude .git "$ROOT/backgrounds/" "$THEME_DIR/backgrounds/"
cp "$ROOT"/colors.toml "$ROOT"/icons.theme "$ROOT"/unlock.png "$ROOT"/preview.png "$ROOT"/preview-unlock.png "$THEME_DIR/"
mkdir -p "$THEME_DIR/src"
rsync -a --delete "$ROOT/src/" "$THEME_DIR/src/"

say "Icon theme → $ICON_DIR"
mkdir -p "$ICON_DIR"
rsync -a --delete "$ROOT/icons/ZAR/" "$ICON_DIR/"

say "Fonts → $FONT_DIR"
mkdir -p "$FONT_DIR"
cp "$ROOT/fonts/ZARIcons.ttf" "$FONT_DIR/"
if compgen -G "$ROOT/fonts/private/*.[ot]tf" >/dev/null; then
  cp "$ROOT"/fonts/private/*.[ot]tf "$FONT_DIR/"
fi
fc-cache -f "$FONT_DIR"

say "Menu glyphs → $EXT_DIR/omarchy-menu.jsonc"
mkdir -p "$EXT_DIR"
if [[ -f $EXT_DIR/omarchy-menu.jsonc ]] && ! cmp -s "$ROOT/shell/omarchy-menu.jsonc" "$EXT_DIR/omarchy-menu.jsonc" \
   && ! grep -q "ZAR brand glyphs" "$EXT_DIR/omarchy-menu.jsonc"; then
  cp "$EXT_DIR/omarchy-menu.jsonc" "$EXT_DIR/omarchy-menu.jsonc.bak.$STAMP"
  say "  (your previous menu extension was kept as omarchy-menu.jsonc.bak.$STAMP)"
fi
cp "$ROOT/shell/omarchy-menu.jsonc" "$EXT_DIR/omarchy-menu.jsonc"

say "Bar widgets → $PLUGIN_DIR/zar.*"
mkdir -p "$PLUGIN_DIR"
for src in "$ROOT"/shell/plugins/zar.*; do
  rsync -a --delete "$src/" "$PLUGIN_DIR/$(basename "$src")/"
done

# Point the bar layout at the ZAR widgets. Each zar.* plugin records which
# stock plugin it replaces; any widget using that stock id (or another clone
# of it) is switched over.
if [[ -f $SHELL_JSON ]]; then
  say "Bar layout → $SHELL_JSON"
  map='{}'
  for m in "$ROOT"/shell/plugins/zar.*/manifest.json; do
    ours=$(jq -r .id "$m"); from=$(jq -r '.omarchy.clonedFrom // empty' "$m")
    [[ -n $from ]] || continue
    map=$(jq -c --arg k "$from" --arg v "$ours" '. + {($k):$v}' <<<"$map")
    for other in "$PLUGIN_DIR"/*/manifest.json; do
      oid=$(jq -r .id "$other" 2>/dev/null || true)
      [[ -n $oid && $oid != "$ours" && $(jq -r '.omarchy.clonedFrom // empty' "$other") == "$from" ]] \
        && map=$(jq -c --arg k "$oid" --arg v "$ours" '. + {($k):$v}' <<<"$map")
    done
  done
  cp "$SHELL_JSON" "$SHELL_JSON.bak.$STAMP"
  jq --argjson map "$map" '
    if (.bar.layout|type)=="object" then
      .bar.layout |= with_entries(.value |= map(if (.id? and $map[.id]) then .id = $map[.id] else . end))
    else . end' "$SHELL_JSON.bak.$STAMP" > "$SHELL_JSON"
fi

# Interface font: Baikal if it is installed (fonts/private or system-wide).
if fc-list | grep -qi "Baikal"; then
  gsettings set org.gnome.desktop.interface font-name 'Baikal 11' 2>/dev/null || true
fi

# Project folders get the briefcase; GTK has no standard name for it.
if [[ -d $HOME/Projects ]] && command -v gio >/dev/null; then
  gio set "$HOME/Projects" metadata::custom-icon-name folder-projects 2>/dev/null || true
fi

say "Applying theme"
omarchy-theme-set "$SLUG"
# Omarchy generates a Claude Code theme from colors.toml but only switches
# Claude Code to it on request.
command -v omarchy-theme-set-claude >/dev/null && omarchy-theme-set-claude --activate 2>/dev/null || true
omarchy-restart-shell >/dev/null 2>&1 || omarchy restart shell >/dev/null 2>&1 || true

say "Done. Theme: $SLUG · icons: ZAR · glyph font: ZARIcons"
