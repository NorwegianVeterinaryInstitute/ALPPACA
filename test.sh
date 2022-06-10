#!/bin/bash

script_directory=$(dirname ${BASH_SOURCE[0]})

track=$1
input=$2
outdir=$3
profile=$4
config=${script_directory}/test.config
work_path=${5%/}

if [[ $track =~ core_genome ]]; then workdir=${work_path}/alppaca_core_genome; fi
if [[ $track =~ mapping ]]; then workdir=${work_path}/alppaca_mapping; fi
if [[ $track =~ core_gene ]]; then workdir=${work_path}/alppaca_core_gene; fi

mkdir -p ${outdir}/config_files
mkdir -p ${outdir}/logs
cp ${script_directory}/main.nf ${outdir}/config_files
cp ${config} ${outdir}/config_files
commitid=$(git --git-dir ${script_directory}/.git branch -v | grep "\*" | awk '{print $2, $3}')
version=$(git --git-dir ${script_directory}/.git tag | tail -1)
echo "ALPPACA version $version, commit-id $commitid" > ${outdir}/logs/version.log

nextflow_21.10.6 run ${script_directory}/main.nf -c ${config} --out_dir=${outdir} --track=${track} --assemblies=${input}/*fasta --reads=${input}/*fastq.gz -work-dir ${workdir} -profile $profile -resume -with-trace ${outdir}/logs/NEXTFLOW_trace.txt -with-timeline ${outdir}/logs/NEXTFLOW_timeline.html
