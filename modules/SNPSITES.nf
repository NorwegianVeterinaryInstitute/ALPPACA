process SNPSITES_FCONST {
	conda (params.enable_conda ? 'bioconda::snp-sites=2.5.1' : null)
	container 'quay.io/biocontainers/snp-sites:2.5.1--h5bf99c6_1'

	label 'process_short'

        input:
        file(snp_alignment)

        output:
        stdout emit: fconst_ch

        shell:
        '''
        fconst_val=`snp-sites -C !{snp_alignment}`
	echo -n $fconst_val
        '''
}

process SNPSITES {
	conda (params.enable_conda ? 'bioconda::snp-sites=2.5.1' : null)
        container 'quay.io/biocontainers/snp-sites:2.5.1--h5bf99c6_1'

	label 'process_short'

        input:
        file(snp_alignment)

        output:
	file("*")
        path "snp_sites_alignment*", emit: snp_sites_aln_ch

        script:
        """
	snp-sites -V > snp-sites.version
        snp-sites -m -o snp_sites_alignment.aln $snp_alignment &> snp_sites.log
        """
}

