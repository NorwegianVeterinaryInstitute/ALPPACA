process CHEWBBACA_DOWNLOAD_SCHEMA {
    conda (params.enable_conda ? 'bioconda::chewbbaca=3.1.0' : null)
    container 'quay.io/biocontainers/chewbbaca:3.1.0--pyhdfd78af_0'

    label 'process_local'

    input:
    val(species)
    val(id)

    output:
    file ("*")
    path "./schema/*", emit: schema_ch

    script:
    """
    chewBBACA.py DownloadSchema -sp $species -sc $id -o ./schema --latest
    """
}

process CHEWBBACA_ALLELECALL {
    conda (params.enable_conda ? 'bioconda::chewbbaca=3.1.0' : null)
    container 'quay.io/biocontainers/chewbbaca:3.1.0--pyhdfd78af_0'

    label 'process_high_memory_time'

    input:
    path(input_file)
    path(schema)

    output:
    path "results*/results_alleles.tsv", emit: typing_ch
    file ("*")

    script:
    """
    chewBBACA.py AlleleCall -i $input_file\
	-g $schema\
	-o .\
	--force-continue\
	--cpu $task.cpus &> chewbbaca.log
    """
}
