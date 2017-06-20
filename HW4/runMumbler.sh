#!/bin/bash

#
# runMumbler.sh
# this script runs the mumbler code
#

if [ $# != 2 ]; then
    echo "Usage: ./runMumbler.sh <start word> <max loops>"
    exit
fi

word=$1
maxMumbles=$2
stopWord="No More Words"
printf "\n    $word "

i=0
while [ $i -lt $maxMumbles ]; do

    # run the word finder locally on each server, concatenate the output, and pipe it 
    # into the mumbler. Store the output so we can pass it in for the next round
    newWord="
    $( (ssh root@gpfs1 "cd /gpfs/gpfsfpo/gpfs1 && ../Find2Grams.sh "$word""; 
        ssh root@gpfs2 "cd /gpfs/gpfsfpo/gpfs2 && ../Find2Grams.sh "$word""; 
        ssh root@gpfs3 "cd /gpfs/gpfsfpo/gpfs3 && ../Find2Grams.sh "$word"";
       ) | /gpfs/gpfsfpo/mumbler.py)"
    
    printf "$newWord "
    
    if [[ "$newWord" == *"$stopWord"* ]]; then 
	break
    fi
    
    word=$newWord
    let i=i+1
done

printf "\n"

