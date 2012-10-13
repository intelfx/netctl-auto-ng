#!/bin/bash

DESTDIR="$(realpath $DESTDIR)"
[[ "$DESTDIR" ]] || { echo "DESTDIR unset, exiting"; exit 1; }

TAG="${1:-$(git describe)}"
VERSION_VAR="NAW_VERSION"

[[ -z "$TAG" ]] && { TAG="unspecified"; }

echo "==== Installing script version $TAG" >&2

cp -afuT source "$DESTDIR"

while read file; do
	sed -re "s|^${VERSION_VAR}=.*$|${VERSION_VAR}=\"${TAG}\"|" -i "$file"
done < <( find "$DESTDIR" -type f )

echo "==== Installation done" >&2
