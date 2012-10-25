#!/bin/bash

[[ "$1" ]] || { echo "First parameter (source root) unset, exiting"; exit 1; }
ROOTDIR="$(realpath $1)"

[[ "$DESTDIR" ]] || DESTDIR="$ROOTDIR/packaging/output"
DESTDIR="$(realpath $DESTDIR)"

TAG="$(git describe)"
VERSION_VAR="NAW_VERSION"
MD5_VAR="NAW_MD5"

[[ -z "$TAG" ]] && { TAG="unspecified"; }
VERSION="${TAG#v}"
VERSION="${VERSION/-g*/}"
VERSION="${VERSION/-/.}"
NAME="netcfg-auto-wireless-$VERSION"

echo "==== Packaging script at $TAG [version $VERSION]" >&2

rm -rf "$DESTDIR"
install -Dm644 PKGBUILD "$DESTDIR/PKGBUILD"
BASENAME="$(basename "$ROOTDIR")"
tar -cf "$DESTDIR/$NAME.tar" --exclude-vcs --exclude-backups --exclude=packaging --transform "s|^$BASENAME|$NAME/|" -C "$ROOTDIR/.." "$BASENAME"
xz -9e "$DESTDIR/$NAME.tar"
MD5=$(md5sum -b "$DESTDIR/$NAME.tar"* | cut -d' ' -f1)
sed -r -e "s|\%$VERSION_VAR\%|$VERSION|" -e "s|\%$MD5_VAR\%|$MD5|" -i "$DESTDIR/PKGBUILD"

echo "==== Packaging done" >&2
