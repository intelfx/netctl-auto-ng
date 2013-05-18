#!/bin/bash

[[ "$1" ]] || { echo "First parameter (source root) unset, exiting"; exit 1; }

ROOTDIR="$(realpath "$1")"
DESTDIR="$(dirname "$(realpath "$0")")/output"
PKGBUILD="$(dirname "$(realpath "$0")")/PKGBUILD"

TAG="$(git describe)"
VERSION_VAR="NAW_VERSION"
MD5_VAR="NAW_MD5"

[[ -z "$TAG" ]] && { TAG="unspecified"; }
VERSION="${TAG#v}"
VERSION="${VERSION/-g*/}"
VERSION="${VERSION/-/.}"
NAME="v$VERSION"
PREFIX="netctl-auto-ng-$VERSION"

echo "==== (LOCAL) Packaging script at $TAG [version $VERSION]" >&2

rm -rf "$DESTDIR"
install -Dm644 "$PKGBUILD" "$DESTDIR/PKGBUILD"
install -m644 *.install "$DESTDIR"
pushd "$ROOTDIR"
git archive --format=tar --prefix="$PREFIX/" HEAD | xz -9e > "$DESTDIR/${NAME}.tar.xz"
popd
MD5=$(md5sum -b "$DESTDIR/$NAME.tar"* | cut -d' ' -f1)
sed -r -e "s|\%$VERSION_VAR\%|$VERSION|" -e "s|\%$MD5_VAR\%|$MD5|" -i "$DESTDIR/PKGBUILD"

echo "==== Packaging done" >&2
