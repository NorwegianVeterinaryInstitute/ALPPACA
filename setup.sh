#!/bin/bash

container_dir=$1

#### Check if singularity is installed

if ! command -v singularity &> /dev/null
then
    echo "Singularity could not be found, please install"
    exit
fi

#### Move to ouput directory and pull images
mkdir ${container_dir}/alppaca_images

echo "Starting download..."
for img in $(cat container_paths)
do
	img_name=${img##*/}
	singularity pull ${container_dir}/alppaca_images/${img_name} $img
	echo "$img_name complete"
done
