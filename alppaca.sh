#!/bin/bash

script_directory=$(dirname ${BASH_SOURCE[0]})

config=$1
outdir=$2
type=`grep "params.type" $config`

if [[ $type =~ "assembly" ]]; then workdir=${3:-$USERWORK/alppaca_assembly}; fi
if [[ $type =~ "reads" ]]; then workdir=${3:-$USERWORK/alppaca_reads}; fi
if [[ $type =~ "core" ]]; then workdir=${3:-$USERWORK/alppaca_core}; fi

mkdir -p ${outdir}/config_files
cp ${script_directory}/main.nf ${outdir}/config_files
cp ${config} ${outdir}/config_files
commitid=$(git --git-dir ${script_directory}/.git branch -v | grep "\*" | awk '{print $2, $3}')
version=$(git --git-dir ${script_directory}/.git tag | tail -1)
echo "Ellipsis version $version, commit-id $commitid" > ${outdir}/config_files/version.log

nextflow run ${script_directory}/main.nf -c ${config} --out_dir=${outdir} -work-dir ${workdir} -resume
