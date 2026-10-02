# Rock Solid — the ZAR theme for Omarchy

The ZAR brand on an [Omarchy](https://omarchy.org) desktop: palette from the
style guide, concrete 3D icons in the file manager, 2D brand glyphs in the
menu and bar, and the brand textures as wallpapers.

## Gallery

![Backgrounds](docs/backgrounds.gif)

**Files** — concrete folders and file types in Nautilus, 2D brand glyphs in the sidebar

![Files](docs/files.png)

**Menu and bar** — every row drawn with the ZAR glyph font; the Zollar replaces the Omarchy mark

![Menu](docs/menus.png)

![Bar](docs/bar.png)

**Palette** — from the ZAR style guide

![Palette](docs/palette.png)

![Terminal](docs/terminal.png)

All five backgrounds: [logo centred](docs/bg-1-zar-logo-center.png) ·
[logo corner](docs/bg-2-zar-logo-corner.png) · [jasper](docs/bg-3-jasper.png) ·
[marble](docs/bg-4-marble.png) · [concrete](docs/bg-5-concrete.png)

## Install

```bash
git clone https://github.com/zarpay/rock-solid-omarchy-theme ~/.local/share/rock-solid-omarchy-theme
~/.local/share/rock-solid-omarchy-theme/install.sh
```

Update later with `git -C ~/.local/share/rock-solid-omarchy-theme pull && ~/.local/share/rock-solid-omarchy-theme/install.sh`.
Remove with `~/.local/share/rock-solid-omarchy-theme/uninstall.sh`.

The theme files at the repo root are a standard Omarchy theme, so
`omarchy theme install https://github.com/zarpay/rock-solid-omarchy-theme`
also works, but it only installs colors and backgrounds (and names the theme
"rock-solid-omarchy"). Use `install.sh` for the whole package.

## What gets installed

| Piece | Where | What it does |
|---|---|---|
| Theme | `~/.config/omarchy/themes/zar` | `colors.toml` (Gold accent, Quartz magenta, Tanzanite/Serpentine/Limestone from the style guide), 5 backgrounds, lock-screen logo, `claude.json` (Claude Code theme, activated by the installer) |
| Icon theme | `~/.local/share/icons/ZAR` | Concrete folders and file types for Nautilus; 2D brand glyphs as symbolic icons for sidebars and toolbars; inherits Yaru-yellow for the rest |
| Glyph font | `~/.local/share/fonts/zar/ZARIcons.ttf` | The 2D icon set compiled to a font (U+E400…), the way Nerd Fonts work |
| Menu | `~/.config/omarchy/extensions/omarchy-menu.jsonc` | Every root, System, Style and Setup row drawn with ZAR glyphs |
| Bar widgets | `~/.config/omarchy/plugins/zar.*` | Clones of the menu button (Zollar), indicators, update, Tailscale and network widgets with ZAR glyphs; `shell.json` is switched to them |

Brand typefaces (EK Modena, Baikal) are licensed and not in this repo. Put
their TTFs in `fonts/private/` before running `install.sh` and they are
installed too; Baikal then becomes the GTK interface font.

## Backgrounds

1. Black with the ZAR logo centred
2. Black with the ZAR logo bottom-right
3. Jasper
4. Marble
5. Concrete

## Editing

- **Colors**: `colors.toml`, then `omarchy theme set zar`. Omarchy regenerates
  terminal, editor, btop and shell configs from it.
- **Add a 2D glyph**: drop an SVG in `src/icons-2d/`, run
  `scripts/build-glyph-font.sh`, then reference it from
  `shell/omarchy-menu.jsonc` (codepoints in `src/zar-icons-codepoints.json`).
  Existing codepoints never move.
- **Add a 3D icon**: put the 992px PNG in `src/icons-3d-*` and the 512px copy
  under `icons/ZAR/512x512/{places,mimetypes}/<freedesktop-name>.png`.
- **Menu rows**: entries in `shell/omarchy-menu.jsonc` must be full copies of
  the stock row (`/usr/share/omarchy/default/omarchy/omarchy-menu.jsonc`); an
  override replaces every field.
- **Bar widgets**: the clones in `shell/plugins` do not follow Omarchy
  updates. Each manifest records `omarchy.clonedFrom`; re-clone with
  `omarchy plugin clone <id>` and re-apply the glyph edits if upstream changes.
