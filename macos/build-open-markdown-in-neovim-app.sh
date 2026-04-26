#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

app_name="OpenMarkdownInNeovim.app"
script_name="OpenMarkdownInNeovim.applescript"
plist_path="$app_name/Contents/Info.plist"

rm -rf "$app_name"
/usr/bin/osacompile -o "$app_name" "$script_name"

/usr/bin/plutil -replace CFBundleName -string "Open Markdown in Neovim" "$plist_path"
/usr/bin/plutil -replace CFBundleDisplayName -string "Open Markdown in Neovim" "$plist_path"
/usr/bin/plutil -replace CFBundleIdentifier -string "com.charliepeters.open-markdown-in-neovim" "$plist_path"
/usr/bin/plutil -replace CFBundleDocumentTypes -json '[
  {
    "CFBundleTypeName": "Markdown Document",
    "CFBundleTypeRole": "Editor",
    "LSHandlerRank": "Alternate",
    "LSItemContentTypes": [
      "public.markdown",
      "net.daringfireball.markdown"
    ],
    "CFBundleTypeExtensions": [
      "md",
      "markdown",
      "mdown",
      "mkd"
    ]
  }
]' "$plist_path"

/usr/bin/plutil -lint "$plist_path"
/usr/bin/codesign --force --deep --sign - "$app_name"
