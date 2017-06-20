
The mumbler readme

Preprocessing

    The preprocessing that was done is available for view in file preprocessor.sh. The goals were
to eliminate unnecessary data and preaggregate to reduce the file size as much as possible to
speed up searching. The files were each unzipped, sorted by 2-gram, and then all counts for a
particular 2-gram were aggregated. This eliminated the year field which seemed useless in this 
project. The page and volume counts were also deemed useless and removed. The only data cleansing 
was to remove rows that did not contain 2 words. There were a LOT of rows that were missing a 
column, and were therefore useless for this project. Much later in the development process, it was
decided that punctuation was also out of scope. The mumbler.py script performs the punctuation
cleansing by only using words that consist of all alphanumeric characters. This would have been 
better to do during preprocessing, but due to the time constraints, preprocessing could not
be re-run, so it was added in code. (preprocessing took ~12 hours)

Running the program

    The RunMumbler.sh control script takes 2 command line parameters: the starting word, and max 
loops.The program flow proceeds as follows. The start word is sent to the search script on each 
server. Each server only searches the part of the file system that is stored locally--gpfs1 searches
directory /gpfs/gpfsfpo/gpfs1, gpfs2 and gpf3 proceed similarly. When the files were downloaded,
they were downloaded to the gpfs drive but each server downloaded a third of the files because of
the local write affinity we are using. When the search script finishes on each server, the results
are returned to and concatenated by the control script and piped into mumbler.py. There, all word
counts are aggregated and one is chosen based on a random number and the words' probabilities. This
word is returned to the control script, and the the process repreats if it hasn't hit max loops yet.
In the event that no 2-grams were found for the input word, a control sequence "No More Words" is
returned and the script returns.


Files

runMumbler.sh <start word> <max count>

    - This script runs the mumbler script. It loops a max number of times and takes the output from 
	the current mumbler run and uses it as input for the next mumbler run.

preprocess.sh 
    
    - the script that was run to preprocess the zipped raw data.

Find2Grams.sh 
    
    - finds all 2-grams in a directory of csv files given the first word and outputs for the mumbler.

mumbler.py 

    - takes output from all Find2Grams scripts and uses the words' probabilities to choose an output
	word.

