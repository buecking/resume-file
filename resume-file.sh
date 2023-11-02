#!/bin/bash

DRY=
CLEAN=0

OPTS="$(getopt -l help,dry,clean -o hdc -n "$(basename $0)" -- "$@")"
test $? -gt 1 && exit 1
eval set -- "$OPTS"
while true ; do case "$1" in
        (-c|--clean)	: Process file from beginning
            CLEAN=; shift 1 ;;
        (-d|--dry)	: Only print changes
            DRY=1; shift 1 ;;
        (-h|--help)	: This message
            1>&2 echo "USAGE:" && grep -H -T -o '(\-.*).\:.*$' "$0"
            exit 1;;
        (--) shift; break;;
        (*) 1>&2 echo "$1 not a valid option" && exit 2
    esac
done

test -z "$1" && \
    1>&2 echo "USAGE: $(basename "$0") [-h|opts] PATH" && exit 1
test -p "$1" &&
    1>&2 echo "XXX: I don't work with pipes" && exit 2

LASTLNFILE="$1.lastline"
test -z "$CLEAN" && echo 1 > $LASTLNFILE
test -s "$LASTLNFILE" && LASTLN=$(<"$LASTLNFILE")
CURLN=$(wc -l "$1" | cut -d' ' -f1)

line_number="$LASTLN"
test -z "$DRY" && sed -n "$line_number,\$p" "$1"
test -z "$DRY" && echo $CURLN > $LASTLNFILE ||\
    echo "$line_number new lines; (before after:  $LASTLN $CURLN)"
