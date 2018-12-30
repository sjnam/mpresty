#!/bin/bash

cd $1

ERROR=0

case $2 in
    mplibcode)
        $5 $3
        ERROR=$?
        ;;
    tikzpicture)
        $5 $3
        pdf2svg $3.pdf $3.svg
        ERROR=$?
        ;;
    graphviz)
        $5 -Tsvg $3.gv -o $3.$4
        ERROR=$?
        ;;
    *)
        echo 'NOT SUPPORTED'
esac

rm -rf *.log *.mp *.mpx *.tex *.aux *.pdf *.gv

exit $ERROR
