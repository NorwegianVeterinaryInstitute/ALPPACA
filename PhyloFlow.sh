#!/bin/bash

script_directory=$(dirname ${BASH_SOURCE[0]})

config=$1
outdir=$2
workdir=${3:-$USERWORK/PhyloFlow_work}

mkdir -p ${outdir}/config_files
cp ${script_directory}/main.nf ${outdir}/config_files
cp ${config} ${outdir}/config_files

nextflow run /cluster/projects/nn9305k/vi_src/PhyloFlow/main.nf -c ${config} --out_dir=${outdir} -work-dir ${workdir} -resume
