process REPORT_CORE_GENOME {
	conda (params.enable_conda ? './assets/r_env.yml' : null)
	container 'library://hkaspersen/alppaca/r_base_4.1.2_alppaca:latest'

	label 'process_short'

        input:
	file(parsnp_report)
	file(phylo_data)
	file(phylo_tree)
	file(snpdists)

        output:
        file("*")

        script:
	"""
	cp $baseDir/bin/core_genome_report.Rmd .
       	Rscript $baseDir/bin/gen_report.R "core_genome"
       	"""
}

process REPORT_CORE_GENE {
        conda (params.enable_conda ? './assets/r_env.yml' : null)
        container 'library://hkaspersen/alppaca/r_base_4.1.2_alppaca:latest'

        label 'process_short'

        input:
        file(ngenes_list)
	file(ncontigs_list)
	file(mds_data)
	file(pangenome_data)
	file(phylo_data)
	file(phylo_tree)
	file(snpdists)

        output:
        file("*")

        script:
        """
        cp $baseDir/bin/core_gene_report_dedup.Rmd .
        Rscript $baseDir/bin/gen_report.R "core_gene"
        """
}

process REPORT_MAPPING {
        conda (params.enable_conda ? './assets/r_env.yml' : null)
        container 'library://hkaspersen/alppaca/r_base_4.1.2_alppaca:latest'

        label 'process_short'

        input:
        file(snippy_data)
	file(phylo_data)
	file(phylo_tree)
	file(snpdists)

        output:
        file("*")

        script:
        """
        cp $baseDir/bin/mapping_report_dedup.Rmd .
        Rscript $baseDir/bin/gen_report.R "mapping"
        """
}
