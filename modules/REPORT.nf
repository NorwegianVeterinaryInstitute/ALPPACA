process REPORT {
	conda (params.enable_conda ? './assets/r_env.yml' : null)
	container 'library://hkaspersen/alppaca/r_base_4.1.2_alppaca:latest'

	label 'process_short'

        input:
	file("*")

        output:
        file("*")

        script:
	if (params.track == "core_genome" && !params.deduplicate)
		"""
		cp $baseDir/bin/core_genome_report.Rmd .
        	Rscript $baseDir/bin/gen_report.R "core_genome" false
        	"""
	if (params.track == "core_genome" && params.deduplicate)
		"""
		cp $baseDir/bin/core_genome_report_dedup.Rmd .
                Rscript $baseDir/bin/gen_report.R "core_genome" true
                """
	if (params.track == "core_gene" && !params.deduplicate)
		"""
		cp $baseDir/bin/core_gene_report.Rmd .
                Rscript $baseDir/bin/gen_report.R "core_gene" false
                """
        if (params.track == "core_gene" && params.deduplicate)
                """
		cp $baseDir/bin/core_gene_report_dedup.Rmd .
                Rscript $baseDir/bin/gen_report.R "core_gene" true
                """
        if (params.track == "mapping" && !params.deduplicate)
                """
		cp $baseDir/bin/mapping_report.Rmd .
                Rscript $baseDir/bin/gen_report.R "mapping" false
                """
        if (params.track == "mapping" && params.deduplicate)
                """
		cp $baseDir/bin/mapping_report_dedup.Rmd .
                Rscript $baseDir/bin/gen_report.R "mapping" true
                """
}
