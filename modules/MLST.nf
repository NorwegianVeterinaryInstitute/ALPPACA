process MLST {
    conda (params.enable_conda ? 'bioconda::mlst=2.23.0' : null)
    container 'quay.io/biocontainers/mlst:2.23.0--hdfd78af_1'

    label 'process_high_cpu_time'

    input:
    path(input)
    val(schema)

    output:
    path "mlst_report.tsv", emit: mlst_ch
    path "**"

    script:
    """
    mlst --version > mlst.version
    mlst --legacy --threads $task.cpus --scheme $schema $input > mlst_report.tsv
    """
}
