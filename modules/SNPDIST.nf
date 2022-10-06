process SNPDIST {
	conda (params.enable_conda ? 'bioconda::snp-dists=0.8.2' : null)
	container 'quay.io/biocontainers/snp-dists:0.8.2--h5bf99c6_0'
	
        input:
        file(snp_alignment)

        output:
        file("*")
	path "snp_dists.tab", emit: snpdists_results_ch

        script:
        """
        snp-dists $snp_alignment > snp_dists.tab
        """
}

