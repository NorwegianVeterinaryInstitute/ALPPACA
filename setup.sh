#!/bin/bash

script_directory=$(dirname ${BASH_SOURCE[0]})

container_dir=$1

#### Check if singularity is installed

if ! command -v singularity &> /dev/null
then
    echo "Singularity could not be found, please install"
    exit
fi

#### Move to ouput directory and pull images
mkdir -p ${container_dir}/alppaca_images

echo "Starting download..."
for img in $(cat ${script_directory}/container_paths)
do
	img_name=${img##*/}
	singularity pull ${container_dir}/alppaca_images/${img_name} $img
	echo "$img_name complete"
done