#!/bin/zsh
# Builds the offline web app (GitHub Pages) from ../vallarforgjof.html (the same page as the artifact and Android app).
set -e
cd "$(dirname "$0")"

for s in 180 192 512; do rsvg-convert -w $s -h $s icon.svg -o icon-$s.png; done

# Wrap the page in a full document, swap Google Fonts for the bundled copies, add PWA/iPhone tags.
{
  echo '<!doctype html><html lang="is"><head><meta charset="utf-8">'
  echo '<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">'
  echo '<meta name="apple-mobile-web-app-capable" content="yes">'
  echo '<meta name="mobile-web-app-capable" content="yes">'
  echo '<meta name="apple-mobile-web-app-title" content="Vallarforgjöf">'
  echo '<meta name="apple-mobile-web-app-status-bar-style" content="default">'
  echo '<meta name="theme-color" content="#eef3ef" media="(prefers-color-scheme: light)">'
  echo '<meta name="theme-color" content="#0d1712" media="(prefers-color-scheme: dark)">'
  echo '<link rel="manifest" href="manifest.webmanifest">'
  echo '<link rel="apple-touch-icon" href="icon-180.png">'
  echo '<link rel="icon" href="icon-192.png">'
  echo '<style>html{box-sizing:border-box;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}[hidden]{display:none!important}</style>'
  grep -v -e 'fonts.googleapis.com' -e 'fonts.gstatic.com' ../vallarforgjof.html \
    | sed 's#<meta name="claude:viewport-fit-sides" content="cover">#<link rel="stylesheet" href="fonts.css">#'
  echo '<script>if ("serviceWorker" in navigator) navigator.serviceWorker.register("sw.js");</script>'
  echo '</html>'
} > index.html

# New cache name on every build so phones pick up changes.
sed -i '' "s/^const CACHE = .*/const CACHE = \"vf-$(date +%Y%m%d%H%M%S)\";/" sw.js
echo "Tilbúið: $(pwd)/index.html"
