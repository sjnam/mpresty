#!/bin/bash

cd $1

ERROR=0

case $2 in
    mplibcode)
        $6 $3
        ERROR=$?
        rm -rf $3.mp* $3.log
        ;;
    graphviz)
        $6 -T$5 $3.$4 -o $3.$5
        ERROR=$?
        rm -rf $3.gv
        ;;
    tikzpicture)
        $6 $3
        pdf2svg $3.pdf $3.$5
        ERROR=$?
        rm -rf $3.tex $3.aux $3.pdf $3.log
        ;;
    *)
        echo 'NOT SUPPORTED'
esac

exit $ERROR
