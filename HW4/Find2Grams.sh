#!/bin/bash

#
# Find2Grams.sh
# For each csv file in the directory, the second word and count from each line
# matching the search word are printed to stdout. xargs is used to make use of both
# processors.
#

if [ $# != 1 ]; then
    echo "Usage: ./Find2Grams <leading word>"
    exit
fi

find . -type f -name '*.csv' -print0 | xargs -0 -n1 -P2 grep -e "^\<$1\>" |
gawk ' { print $2 "\t" $3 } '

