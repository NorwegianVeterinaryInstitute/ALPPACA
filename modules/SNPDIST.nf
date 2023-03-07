process SNPDIST {
	conda (params.enable_conda ? 'bioconda::psdm=0.2.0' : null)
	container 'quay.io/biocontainers/psdm:0.2.0--hec16e2b_1'
	
        input:
        file(snp_alignment)

        output:
        file("*")
	path "snp_dists.tab", emit: snpdists_results_ch

        script:
        if (params.snp_long)
		"""
		psdm -V > psdm.version
		psdm -t $task.cpus -l $snp_alignment > snp_dists.tab
        	"""
	else
		"""
		psdm -V > psdm.version
                psdm -t $task.cpus $snp_alignment > snp_dists.tab
		"""
}

