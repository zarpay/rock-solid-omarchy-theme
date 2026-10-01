#!/bin/bash
# Rebuild fonts/ZARIcons.ttf from src/icons-2d/*.svg. Codepoints are pinned in
# src/zar-icons-codepoints.json; new SVGs get the next free codepoint so
# existing menu/bar glyphs never move. Requires node (npx).
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/in" "$WORK/out"
for f in "$ROOT"/src/icons-2d/*.svg; do
  # hole shapes (fill="none") are dropped; the font only needs the ink
  sed -E 's/<path[^>]*fill="none"[^>]*\/>//g; s/<svg([^>]*) fill="none"/<svg\1/' "$f" > "$WORK/in/$(basename "$f")"
done
python3 - "$ROOT" "$WORK" <<'PY'
import json,sys,os,glob
root,work=sys.argv[1],sys.argv[2]
p=os.path.join(root,'src/zar-icons-codepoints.json'); cps=json.load(open(p))
nxt=max(cps.values())+1 if cps else 0xE400
for f in sorted(glob.glob(os.path.join(work,'in','*.svg'))):
    n=os.path.basename(f)[:-4]
    if n not in cps: cps[n]=nxt; nxt+=1
json.dump(cps,open(p,'w'),indent=1)
json.dump({"inputDir":"in","outputDir":"out","name":"ZARIcons","fontTypes":["ttf"],"assetTypes":["json"],"fontHeight":1000,"normalize":True,"codepoints":cps},open(os.path.join(work,'fantasticonrc.json'),'w'))
PY
(cd "$WORK" && npx --yes fantasticon -c fantasticonrc.json >/dev/null)
cp "$WORK/out/ZARIcons.ttf" "$ROOT/fonts/ZARIcons.ttf"
echo "Built fonts/ZARIcons.ttf ($(jq length "$ROOT/src/zar-icons-codepoints.json") glyphs)"
