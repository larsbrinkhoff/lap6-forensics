#!/bin/sh

ASSEMBLER="$HOME/src/lap6/lap6.py"
FILING="$HOME/src/lap6/lap6"
TAPE="fresh-lap6.linc"

filing() {
    "$FILING" "$1" "$TAPE" "$2" "$3"
}

columns() {
    x="-c$1"
    shift
    cut "$x" "$@" | grep -v '^[ ]*$'
}

assemble() {
    echo "Assembling $*"
    columns 11- "$@" > manuscript.lap6
    columns 1-9 "$@" > old.oct
    "$ASSEMBLER" manuscript.lap6 > new.oct
}

quarters() {
    quarters="$1"
    block="$2"
    case "$quarters" in
        *\ *)
            set $quarters
            x=`expr $1 + $2 - 1`
            test "$x" = 9 && x=7
            q="s $1-$x";;
        *)
            q=" $1";;
    esac
    echo "Quarter$q to block $block"
    ./quarters.py $quarters < new.oct | filing wb "$block"
}

cd `dirname "$0"`

filing mk
filing mx

assemble "MSDISPLY"
quarters "0 10" 300

assemble "FILECOMS"
quarters "0 4" 320

assemble "MSDISPLY" "ADDMS LO"
quarters "3" 324

assemble "COPYFILE"
quarters "0 3" 314

assemble "COPY"
quarters "0 2" 336

assemble "CONVERT"
quarters "0 3" 330

assemble "CV DIS"
quarters "0 2" 310

assemble "DISX PX" "TELETYPE"
quarters "0 2" 325

assemble "PRINT MS" "TELETYPE"
quarters 2 322

assemble "LIST" "TELETYPE"
quarters 1 333
quarters 2 327
quarters 3 335
quarters "6 2" 312
quarters 6 317

magic() {
    #2065 5712
    printf '+@\032\012'
}

save_manuscript() {
    (magic; columns 11- "$1" | sed 's/^    //') | filing sm "$1"
}

save_manuscript "MSDISPLY"
save_manuscript "ADDMS LO"
save_manuscript "FILECOMS"
save_manuscript "COPYFILE"
save_manuscript "COPY"
save_manuscript "CONVERT"
save_manuscript "CV DIS"
save_manuscript "DISX PX"
save_manuscript "PRINT MS"
save_manuscript "LIST"
save_manuscript "TELETYPE"
