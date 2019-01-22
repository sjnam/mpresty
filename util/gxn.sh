#!/bin/bash

cd $1

ERROR=0

case $2 in
    mplibcode)
        $5 $3
        ERROR=$?
        ;;
    graphviz)
        $5 -Tsvg $3.gv -o $3.svg
        ERROR=$?
        ;;
    tikzpicture)
        $5 $3
        pdf2svg $3.pdf $3.svg
        ERROR=$?
        ;;
    *)
        echo 'NOT SUPPORTED'
esac

rm -rf *.mp *.mpx *.gv *.tex *.aux *.pdf

exit $ERROR
