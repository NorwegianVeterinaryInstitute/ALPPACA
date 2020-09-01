#!/bin/bash

script_directory=$(dirname ${BASH_SOURCE[0]})

script=$1
config=$2
outdir=$3
workdir=${4:-$USERWORK/PhyloFlow_work}

mkdir -p ${outdir}/config_files
cp ${script_directory}/${script} ${outdir}/config_files
cp ${config} ${outdir}/config_files

nextflow run ${script} -c ${config} --out_dir=${outdir} -work-dir ${workdir} -resume
