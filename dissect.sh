#!/bin/sh

# This extracts LAP6 from tape images, and further picks it apart into
# the sections described by the document LAP6 Manuscript Listings.  It
# then sorts the parts into buckets by taking the SHA1 of the data.
# This makes it convenient to compare various copies of LAP6 from
# different tape images.
#
# Parts:
# MSDISPLY  md  300-307  (Character grid gr locations 2001-2200)
# CV DIS    cd  310-311
# LIST      ls  312-313 + 317 + 333 + 335
# COPYFILE  cf  314-316
# FILECOMS  fc  320-322 + 323
# PRINT MS  pm  322
# ADDMS LO  am  324
# DISX PX   dx  325-326
# CONVERT   cv  330-332
# COPY      cp  336-337

LAP6=../lap6/lap6

rm -rf parts; mkdir parts
mkdir parts/md parts/cd parts/am parts/dx parts/cv parts/gr

add() {
    x1=`printf "%d" "0$1"`
    x2=`printf "%d" "0$2"`
    x3=`expr "$x1" + "$x2"`
    printf "%03o" "$x3"
}

dump() {
    od -v -An -w2 | cut -c4-
}

dice() {
    tape="tapes/$1"
    oct="parts/$2/$1.oct"
    "$LAP6" rb "$tape" "$3" "$4" | dump > "$oct"
    sum=`cat "$oct" | sha1sum | cut -c1-40`
    cp "$oct" "parts/$2/$sum.sha1"
    echo "$2/$1" >> "parts/$2/$sum.list"
}

slice() {
    test "$2" = "-" && return
    md=`add "$2" 00`
    cd=`add "$2" 10`
    am=`add "$2" 24`
    dx=`add "$2" 25`
    cv=`add "$2" 30`
    dice "$1" md "$md" 10
    dice "$1" cd "$cd" 02
    dice "$1" am "$am" 01
    dice "$1" dx "$dx" 02
    dice "$1" cv "$cv" 03

    oct="parts/gr/$1.oct"
    tail -n+1026 "parts/md/$1.oct" | head -126 > "$oct"
    sum=`cat "$oct" | sha1sum | cut -c1-40`
    cp "$oct" "parts/gr/$sum.sha1"
    echo "gr/$1" >> "parts/gr/$sum.list"
}

tape() {
    tape="$1"
    index="$2"
    lap6="$3"
    slice "$tape" "$lap6"
}

cat README.md | while read i; do
    IFS="|"; set $i; IFS=" "
    case "$i" in
        \|\ *.linc\ * | \|\ *.dsk512\ *)
            tape $2 $3 $4;;
    esac
done
