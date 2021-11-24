#!/bin/bash

script_directory=$(dirname ${BASH_SOURCE[0]})

config=$1
outdir=$2
type=`grep "params.type" $config`
container_dir='/cluster/projects/nn9305k/nextflow/alppaca_images'
DATE=($(date "+%Y%m%d_%R"))

if [[ $type =~ "core_genome" ]]; then workdir=${3:-$USERWORK/alppaca_core_genome}; fi
if [[ $type =~ "mapping" ]]; then workdir=${3:-$USERWORK/alppaca_mapping}; fi
if [[ $type =~ "core_gene" ]]; then workdir=${3:-$USERWORK/alppaca_core_gene}; fi

mkdir -p ${outdir}/config_files
cp ${script_directory}/main.nf ${outdir}/config_files
cp ${config} ${outdir}/config_files
commitid=$(git --git-dir ${script_directory}/.git branch -v | grep "\*" | awk '{print $2, $3}')
version=$(git --git-dir ${script_directory}/.git tag | tail -1)
echo "ALPPACA version $version, commit-id $commitid" > ${outdir}/config_files/version.log

module load Java/11.0.2
nextflow run ${script_directory}/main.nf -c ${config} --out_dir=${outdir} --container_dir=${container_dir} -work-dir ${workdir} -resume -with-report ${DATE}.report.html -with-trace
module unload Java/11.0.2
