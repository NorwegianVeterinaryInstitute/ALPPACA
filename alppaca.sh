#!/bin/bash

script_directory=$(dirname ${BASH_SOURCE[0]})

config=$1
outdir=$2
type=`grep "params.type" $config`

if [[ $type =~ "assembly" ]]; then workdir=${3:-$USERWORK/phyloflow_assembly}; fi
if [[ $type =~ "reads" ]]; then workdir=${3:-$USERWORK/phyloflow_reads}; fi
if [[ $type =~ "core" ]]; then workdir=${3:-$USERWORK/phyloflow_core}; fi

mkdir -p ${outdir}/config_files
cp ${script_directory}/main.nf ${outdir}/config_files
cp ${config} ${outdir}/config_files

nextflow run ${script_directory}/main.nf -c ${config} --out_dir=${outdir} -work-dir ${workdir} -resume
