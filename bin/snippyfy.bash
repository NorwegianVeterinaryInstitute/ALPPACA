#!/bin/bash

# Get input data
R1_reg=$1
R2_reg=$2
outname=$3

R1=`ls -C1 $R1_reg`
R2=`ls -C1 $R2_reg`

# Create files to merge
for i in $R1; do
	basename=`basename $i`
	samplename=${basename%%$outname}
	echo $samplename >> samplename.list
done

printf '%s\n' "${R1}" > R1.list
printf '%s\n' "${R2}" > R2.list

# Merge files into tab-separated file

paste samplename.list R1.list R2.list > snippy_samples.list
sed -i '1i #ID	R1	R2' snippy_samples.list
