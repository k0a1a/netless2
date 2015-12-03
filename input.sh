#!/bin/sh

while :; do

echo -n ': '
read input

date=$(date +%s)

echo -n "$input" | hexinject-min -x | sh ./updatedb.sh

#echo -n "$date: $input"

done
