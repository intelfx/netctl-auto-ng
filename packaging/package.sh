#!/bin/bash

[[ "$1" ]] || { echo "First parameter (source root) unset, exiting"; exit 1; }
ROOTDIR="$(realpath $1)"

[[ "$DESTDIR" ]] || DESTDIR="$ROOTDIR/packaging/output"
DESTDIR="$(realpath $DESTDIR)"

TAG="$(git describe)"
VERSION_VAR="NAW_VERSION"

[[ -z "$TAG" ]] && { TAG="unspecified"; }
VERSION="${TAG#v}"
VERSION="${VERSION/-g*/}"
VERSION="${VERSION/-/.}"
NAME="netcfg-auto-wireless-$VERSION"

echo "==== Packaging script at $TAG [version $VERSION]" >&2

git push --all -f

rm -rf "$DESTDIR"/{pkg,src,PKGBUILD}
install -Dm644 PKGBUILD "$DESTDIR/PKGBUILD"
sed -r -e "s|\%$VERSION_VAR\%|$VERSION|" -i "$DESTDIR/PKGBUILD"
pushd "$DESTDIR"
makepkg -g >> PKGBUILD
popd

echo "==== Packaging done" >&2
