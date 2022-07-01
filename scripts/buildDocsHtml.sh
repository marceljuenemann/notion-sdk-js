#!/bin/bash
set -xeo pipefail

script_dir=$(dirname "$(readlink -f "$0")")
repo_root="$(git rev-parse --show-toplevel)"
build_dir="$repo_root/docs-build"

# TODO: Figure out if we can vendor this.
wget -qO "$build_dir"/GitHub.html5 "https://raw.githubusercontent.com/tajmone/pandoc-goodies/master/templates/html5/github/GitHub.html5"

html_dir="$build_dir"/html
mkdir -p "$html_dir"

set +x
for file in "$build_dir/markdown"/*.md; do
	echo "Converting $file to HTML..."
  pandoc "$file" \
		--template="$build_dir"/GitHub.html5 \
		-f markdown \
		-t html5 \
		-o "$html_dir"/"$(basename "$file" | sed '$s/\.md$/.html/')" \
		-s \
		--lua-filter="$script_dir"/links-to-html.lua
done
set -x