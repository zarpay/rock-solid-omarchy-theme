# Changelog

All notable changes to the Rock Solid theme. Dates are when the change
landed on `main`.

## 1.1.0 — 2026-10-02

### Added
- `claude.json`: a hand-tuned Claude Code theme shipped with the theme. Quartz
  pink on suggestions, the `!` bash border, merged markers and the ultracode
  tag; style-guide orange on warnings, memory and fast mode; Tanzanite on plan
  mode and permission prompts; stronger diff backgrounds; brand-mapped subagent
  and rainbow colors.
- `install.sh` activates the Claude Code theme (`theme: "custom:omarchy"` in
  `~/.claude/settings.json`), so a fresh install gets it without a manual
  `/theme` pick.
- README gallery: background cycle GIF, Nautilus with every file type, the
  menu and bar, the palette card and a terminal sample.

### Changed
- README install instructions use a plain `git clone` now that the repo is
  public, and the repo was renamed to `rock-solid-omarchy-theme`.

## 1.0.0 — 2026-10-01

First release.

- `colors.toml` built from the Mattermost palette and aligned to the ZAR
  style guide: Gold accent, Quartz magenta, Tanzanite blue, Serpentine green,
  Limestone brown, Grey 1/3/4 foregrounds.
- Five backgrounds: ZAR logo centred, ZAR logo bottom-right, jasper, marble,
  concrete. Lock-screen logo.
- ZAR icon theme over Yaru-yellow: concrete 3D folders and file types for
  Nautilus, the 2D brand set as symbolic icons for sidebars and toolbars.
- ZARIcons glyph font compiled from the 2D set (U+E400…), plus four drawn
  glyphs the set lacked: Zollar, gear, folder, file.
- Omarchy menu rows (root, System, Style, Setup) drawn with ZAR glyphs.
- Bar widget clones with ZAR glyphs: menu button (Zollar), indicators,
  update, Tailscale (shield), network (globe).
- `install.sh` / `uninstall.sh`, `scripts/build-glyph-font.sh`.
