#!/bin/bash

echo "$# arguments were passed"
echo "input frame directory: $1"
echo "output frame directory: $2"
echo "model path: $3"

for f in $1/*.jpg
	do
		filename=$(basename $f)
		outputpath="$2/$filename"
		echo "processing file $filename"
		python generate.py $f -m $3 -o $outputpath -g 0
		#cp $f $outputpath
	done



