#!/bin/bash

#
# preprocess.sh
# Preprocess the zipped files. To reduce the unzipped size, each file is unzipped, sorted
# by word 1, then word 2, and then all year counts are aggregated to speed up searches.
# This aggregation has the added benefit of reducing the file size enough that they can
# all stay unzipped on disk. Rows with missing columns were stripped because they are not
# useful for this application.
# 

for ifname in *.zip; do

  ofname=${ifname/.zip/}
  printf "File: $ifname \n"
  
  unzip -p $ifname |
    sort -t $'\t' -k1,1 -k2,2 |
    gawk '
      BEGIN { word1 = ""; word2 = ""; count = 0; }
      {
        if( NF == 6) {
          if( word1 != $1 || word2 != $2)
          {
            if( count > 0) print word1 "\t" word2 "\t" count;
            word1 = $1;
            word2 = $2;
            count = $4;
          }
          else count += $4;
        }
      }
      END { if( count > 0) print word1 "\t" word2 "\t" count;}' > $ofname

done
