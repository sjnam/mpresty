#!/bin/bash

cd $1

ERROR=0

case $2 in
    mplibcode)
        $5 $3
        rm -rf *.mp *.mpx
        ERROR=$?
        ;;
    tikzpicture)
        $5 $3
        pdf2svg $3.pdf $3.svg
        rm -rf *.tex *.aux *.pdf
        ERROR=$?
        ;;
    graphviz)
        $5 -Tsvg $3.gv -o $3.$4
        rm -rf *.gv
        ERROR=$?
        ;;
    sudoku)
        $5 $3
        rm -rf *.dlx
        ERROR=$?
        ;;
    *)
        echo 'NOT SUPPORTED'
esac

rm -rf *.log

exit $ERROR
