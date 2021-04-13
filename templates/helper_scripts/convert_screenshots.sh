#!/bin/bash

for PHOTO in *.png
   do
       BASE=`basename $PHOTO`
       convert "$PHOTO" -trim \( +clone -background grey25 -shadow 40x45+0+40 \) +swap -background transparent -layers merge +repage "converted/$BASE"
   done