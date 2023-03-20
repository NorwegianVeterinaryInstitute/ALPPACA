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
	val(n_lines)

        output:
        path "*"
        path "dissimilarity_matrix.tsv", emit: dissimilarity_ch
	path "hamming_distances.tsv", emit: hamming_ch
	path "dendrogram.phylo", emit: tree_ch

	when: n_lines >= 3

        script:
        """
        Rscript $baseDir/bin/calculate_distances.R $clustering_method
        """
}

