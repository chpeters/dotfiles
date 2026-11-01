#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

app_name="OpenMarkdownInNeovim.app"
script_name="OpenMarkdownInNeovim.applescript"
build_dir=$(mktemp -d "$PWD/.markdown-launcher.XXXXXX")
staged_app="$build_dir/$app_name"
previous_app="$build_dir/previous.app"
cleanup() {
    if [ -e "$previous_app" ] && [ ! -e "$app_name" ]; then
        mv "$previous_app" "$app_name"
    fi
    rm -r "$build_dir"
}
trap cleanup EXIT
plist_path="$staged_app/Contents/Info.plist"

/usr/bin/osacompile -o "$staged_app" "$script_name"

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
/usr/bin/codesign --force --deep --sign - "$staged_app"
/usr/bin/codesign --verify --deep --strict "$staged_app"

# Keep the working app until compilation and verification have succeeded.
if [ -e "$app_name" ]; then
    mv "$app_name" "$previous_app"
fi
mv "$staged_app" "$app_name"
