#!/bin/bash

cd $1

ERROR=0

case $2 in
    mplibcode)
        $6 $3
        ERROR=$?
        ;;
    graphviz)
        $6 -T$5 $3.$4 -o $3.$5
        ERROR=$?
        ;;
    *)
        echo 'NOT SUPPORTED'
esac

rm -rf *.mp *.mpx *.gv *.log

exit $ERROR
