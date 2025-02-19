process PARSNP {
	conda (params.enable_conda ? 'bioconda::parsnp=2.1.3' : null)
	container 'quay.io/biocontainers/parsnp:2.1.3--h077b44d_0'

	label 'process_long'

        input:
        file(fasta)

        output:
	path "parsnp_alignment.fasta", emit: fasta_alignment_ch
	path "parsnpAligner.log", emit: parsnp_results_ch
	file("*")

        script:
        """
	parsnp --version > parsnp.version
        parsnp -d $fasta -p $task.cpus --skip-phylogeny -u -o results -r $params.parsnp_ref -v -c &> parsnp.log
	mv results/log/parsnpAligner.log .
	mv results/parsnp.ggr .
	mv results/parsnp.xmfa .
	mv results/parsnp.unalign . 
	harvesttools -x *xmfa -M parsnp_alignment.fasta
        """
}
