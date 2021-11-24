#!/bin/bash

container_dir=$1

#### Check if singularity is installed

if ! command -v singularity &> /dev/null
then
    echo "Singularity could not be found, please install"
    exit
fi

#### Check if all images can be downloaded
echo "Checking to see if all containers can be downloaded..."

for url in $(cat container_paths) 
do 
  if curl --output /dev/null --silent --head --fail "$url"; then
    echo "URL exists: $url"
  else
    echo "URL does not exist: $url"
  fi 
done


#### Move to ouput directory and pull images
mkdir ${container_dir}/alppaca_images
cd ${container_dir}/alppaca_images

echo "Starting download..."
echo "All images downloaded!"
