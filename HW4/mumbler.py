#!/usr/bin/env python

### 
### mumbler.py
### Input:  tab delimited data on stdin, each line must contain word\tcount
### Output: the chosen word based on count probablities
### 
### The mumbler is used to choose a word based on its relative probability in the input file.
### The input file to mumbler contains a column of words and a column of their counts.
### 

import sys
import csv
from collections import defaultdict
from random import randint

def mumble():
    """mumbler - aggregate input file word counts and output a word based on its probability
    Our input file passes in on stdin and has on each line: word\tcount"""
    
    reader = csv.reader( sys.stdin, delimiter='\t')
    wordCounts = defaultdict(int)
    totalCount = 0
    
    # line[0] contains the word
    # line[1] contains the count
    for line in reader:
	# occasional bad data is in the count field, so we must be careful
        try: 
	    # only deal with alphanumeric characters
	    if( line[0].isalnum()):
	    	# read into dictionary
	    	wordCounts[ line[0]] += int(line[1])
		
	    	# update count
            	totalCount += int(line[1])
	except:
	    pass
    
    if( totalCount == 0):
	return "No More Words"
    
    # create random selector
    selector = randint(1, totalCount)
    
    # walk the dictionary and choose the output word based on probability
    # - by subtracting each word's count from the (random) selector number, 
    #   we are effectively choosing the output word at random based on it's
    #   local probability
    outWord = ""
    for k, v in wordCounts.items():
        selector -= v
        if( selector <= 0):
            outWord = k
            break
    
    return outWord

print mumble()


