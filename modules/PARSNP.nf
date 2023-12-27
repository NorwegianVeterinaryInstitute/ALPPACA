process PARSNP {
	conda (params.enable_conda ? 'bioconda::parsnp=1.7.4' : null)
	container 'quay.io/biocontainers/parsnp:1.7.4--hdcf5f25_2'

	label 'process_long'

        input:
        file("*")

        output:
	path "parsnp_alignment.fasta", emit: fasta_alignment_ch
	path "parsnpAligner.log", emit: parsnp_results_ch
	file("*")

        script:
        """
	parsnp --version > parsnp.version
        parsnp -d *.fasta -p 4 --skip-phylogeny -u -o results -r $params.parsnp_ref -v -c &> parsnp.log
	mv results/* .
	harvesttools -x *xmfa -M parsnp_alignment.fasta
        """
}
