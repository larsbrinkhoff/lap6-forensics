#!/bin/sh

LAP6=$HOME/src/lap6/lap6.py

build() {
    cat "$@" | cut -c11- > TMP.$$
    cat "$@" | cut -c1-9 | grep -v '^[ ]*$' > TMP1
    "$LAP6" TMP.$$ > TMP3
}

cd `dirname "$0"`
#build "MSDISPLY"
#build "MSDISPLY" "ADDMS LO"
build "FILECOMS"
#build "COPYFILE"
#build "COPY"
#build "CONVERT"
#build "CV DIS"
#build "DISX PX" "TELETYPE"
#build "PRINT MS" "TELETYPE"
#build "LIST" "TELETYPE"
