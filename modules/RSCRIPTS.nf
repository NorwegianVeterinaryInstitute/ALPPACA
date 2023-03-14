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
