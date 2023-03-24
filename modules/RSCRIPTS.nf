process CLEAN_AND_FILTER {
        conda (params.enable_conda ? './assets/r_env.yml' : null)
        container 'evezeyl/r_docker:latest'

        input:
        path(report)
	val(alleles)

        output:
        path "*"
	path "filtered_allele_results.tsv", emit: filtered_alleles_ch

        script:
        """
        Rscript $baseDir/bin/filter_cgmlst_data.R $alleles
        """
}

process CALCULATE_DISTANCES {
        conda (params.enable_conda ? './assets/r_env.yml' : null)
        container 'evezeyl/r_docker:latest'

        input:
        path(report)
        val(clustering_method)
	val(n_length)

        output:
        path "*"
        path "dissimilarity_matrix.tsv", emit: dissimilarity_ch
	path "hamming_distances.tsv", emit: hamming_ch
	path "dendrogram.phylo", emit: tree_ch

	script:
	if (n_length < 25) {
	    throw GroovyException("Too few genomes passed filtering, please adjust --max_missing")
	} else {
	    """
	    Rscript $baseDir/bin/calculate_distances.R $clustering_method
	    """
	}
}
