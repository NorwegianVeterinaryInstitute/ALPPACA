process CHEWBBACA {
    publishDir "$params.outdir/chewbbaca", pattern: "*", mode: "copy", failOnError: true
    input:
    path 'assemblies_dir'
    path 'schema_dir'
    val params.outdir
		
    output:
    path "results*/results_alleles.tsv", emit: typing_ch
    file ("*")
    
    script:
    """
    chewBBACA.py AlleleCall -i assemblies_dir -g schema_dir -o . &> chewbbaca.log
    """
}
