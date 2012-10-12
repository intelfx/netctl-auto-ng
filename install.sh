#!/bin/bash

DESTDIR="$(realpath $DESTDIR)"

cd source
while read file; do
	install -D "$file" "$DESTDIR/$file"
done < <( find . -type f )
cd ..
