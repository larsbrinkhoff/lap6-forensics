#!/bin/sh

# Compare some part of LAP6 across all tape images.  The input is the
# output from dissect.sh.  The metric is number of words that differ.

# Parts: md cd am dx cv gr

part="${1:-md}"
temp="$PWD/temp"
rm -rf "$temp"; mkdir "$temp"

compare() {
    mv "$1" "$temp"
    test -z "`ls *.sha1 2>/dev/null`" && return
    for i in *.sha1; do
        x=`diff -u "$temp/$1" "$i" | grep '^[+]' | wc -l`
        a=`basename $1 .sha1`.list; a=`head -1 $a`
        b=`basename $i .sha1`.list; b=`head -1 $b`
        echo "$x $a $b"
    done
}

cd parts/"$part"
for i in *.sha1; do
    compare "$i"
done | sort -n
cd "$temp"
mv * ../parts/"$part"
