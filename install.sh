#!/bin/bash

DESTDIR="$(realpath $DESTDIR)"
TAG="$(git describe)"
VERSION_VAR="NAW_VERSION"

[[ -z "$TAG" ]] && { TAG="unspecified"; }

echo "==== Installing script version $TAG" >&2

cd source
while read file; do
	echo "- $file" >&2
	rm -f "$DESTDIR/$file"
	install -D "$file" "$DESTDIR/$file"
	sed -re "s|^${VERSION_VAR}=.*$|${VERSION_VAR}=\"${TAG}\"|" -i "$DESTDIR/$file"
done < <( find . -type f )
cd ..

echo "==== Installation done" >&2
