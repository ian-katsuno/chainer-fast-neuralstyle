#!/bin/bash

echo "$# arguments were passed"
echo "style image path: $1"
echo "style image width: $2"
echo "style image height: $3"

# put arguments into variables
style_image=$1
width=$2
height=$3

#process the arguments
style_image_filename=$(basename $style_image)
style_image_name=$(echo "$style_image_filename" | cut -f 1 -d '.')
let "nPixels = $width * $height"

#print our computed values
echo $style_image_name
echo "total pixels in style image = $nPixels"


# TYLER! 
	# if you want to change what different lambda_noise values we sweep through then simply add
	# or remove values from the list below after the word 'in'
	# the default lambda noise that they are using in the article is 1000
for lambda_noise in 500 1000 2000 4000
do

	# TYLER! 
		# if you want to change what different noise_count values we go through edit the line below.
		# the noise count values below are what fraction of all pixels we are adding noise to - 0.005 means 0.5%
	for noise_count_percent in 0.005 0.01 0.015 0.02
	do	
		#compute how many pixels for this percentage of the total pixels
		noise_count=$(echo "print(int(round($nPixels * $noise_count_percent)))" | python)

		# TYLER!
			# the line below is where we specify what noise_range values we want to sweep through
			# simply add or remove new values from the list below after the word 'in'
		for noise_range in 10 20 40 80
		do
			model_name=$(echo "$style_image_name-lambda_noise-$lambda_noise-noise_count-$noise_count-noise_range-$noise_range")
			log_name=$(echo "$style_image_name-lambda_noise-$lambda_noise-noise_count-$noise_count-noise_range-$noise_range.log")
			
			echo "now training on style image $style_image_filename, with lambda_noise=$lambda_noise, noise_count=$noise_count, noise_range=$noise_range"
			python train.py -o $model_name -d ../../train2014 -g 0 -s $style_image --lambda_noise $lambda_noise --noisecount $noise_count --noise $noise_range >> $log_name 2>&1
			
			#after we're done, move the models into a folder
			#touch $(echo "$model_name.model")
			mkdir $(echo "models/$model_name")
			mv $(echo "$model_name*") $(echo "models/$model_name")
		done
	done
done
