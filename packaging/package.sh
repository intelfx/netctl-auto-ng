#!/bin/bash

[[ "$1" ]] || { echo "First parameter (source root) unset, exiting"; exit 1; }

ROOTDIR="$(realpath "$1")"
DESTDIR="$(dirname "$(realpath "$0")")/output"
PKGBUILD="$(dirname "$(realpath "$0")")/PKGBUILD"

TAG="$(git describe)"
VERSION_VAR="NAW_VERSION"

[[ -z "$TAG" ]] && { TAG="unspecified"; }
VERSION="${TAG#v}"
VERSION="${VERSION/-g*/}"
VERSION="${VERSION/-/.}"
NAME="netctl-auto-wireless-$VERSION"

echo "==== Packaging script at $TAG [version $VERSION]" >&2

git push --all -f
git push --tags -f

rm -rf "$DESTDIR"/{pkg,src,PKGBUILD,*.install}
install -Dm644 "$PKGBUILD" "$DESTDIR/PKGBUILD"
install -m644 *.install "$DESTDIR"
sed -r -e "s|\%$VERSION_VAR\%|$VERSION|" -i "$DESTDIR/PKGBUILD"
pushd "$DESTDIR"
makepkg -g >> PKGBUILD
popd

echo "==== Packaging done" >&2
