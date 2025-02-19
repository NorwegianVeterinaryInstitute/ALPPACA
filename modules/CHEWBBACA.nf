process CHEWBBACA_DOWNLOAD_SCHEMA {
    conda (params.enable_conda ? 'bioconda::chewbbaca=3.3.10' : null)
    container 'quay.io/biocontainers/chewbbaca:3.3.10--pyhdfd78af_0'

    label 'process_local'

    input:
    val(species)
    val(id)

    output:
    path "*"
    path "schema/*", emit: schema_ch
    path "schema"

    script:
    """
    chewBBACA.py DownloadSchema -sp $species -sc $id -o ./schema --latest
    """
}

process CHEWBBACA_PREP_SCHEMA {
    conda (params.enable_conda ? 'bioconda::chewbbaca=3.3.10' : null)
    container 'quay.io/biocontainers/chewbbaca:3.3.10--pyhdfd78af_0'

    input:
    path(schema)
    path(ptf)

    output:
    path "*"
    path "prepped_schema", emit: schema_ch
    path "prepped_schema_summary_stats.tsv", emit: schema_stats_ch

    script:
    """
    chewBBACA.py PrepExternalSchema -g $schema\
	-o ./prepped_schema\
	--ptf $ptf\
	--bsr $params.bsr\
	--l $params.min_len\
	--t $params.translation_table\
	--st $params.size_threshold\
	--cpu $task.cpus
    """
}

process CHEWBBACA_EVAL_SCHEMA {
    conda (params.enable_conda ? 'bioconda::chewbbaca=3.3.10' : null)
    container 'quay.io/biocontainers/chewbbaca:3.3.10--pyhdfd78af_0'

    input:
    path(schema)

    output:
    path "*"

    script:
    """
    chewBBACA.py SchemaEvaluator -g $schema\
        -o results\
        --cpu $task.cpus
    """
}

process CHEWBBACA_ALLELECALL {
    conda (params.enable_conda ? 'bioconda::chewbbaca=3.3.10' : null)
    container 'quay.io/biocontainers/chewbbaca:3.3.10--pyhdfd78af_0'

    label 'process_high_memory_cpu_time'

    input:
    path(input)
    path(schema)

    output:
    path "results/results_alleles.tsv", emit: typing_ch
    path "results/results_statistics.tsv", emit: allelecall_stats_ch
    path "results/loci_summary_stats.tsv", emit: loci_stats_ch
    path "**"

    script:
    """
    chewBBACA.py --version > chewbbaca.version
    chewBBACA.py AlleleCall -i .\
	-g $schema\
	-o results\
	--force-continue\
	--output-missing\
	--output-unclassified\
	--mode $params.mode\
	--cpu $task.cpus &> chewbbaca_allelecall.log
    """
}
