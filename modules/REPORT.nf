process REPORT_CORE_GENOME_DEDUP {
        publishDir "${params.out_dir}/results", pattern: "*report.html", mode: "copy"

	label 'shorttime'

        input:
        file(parsnp_report)
	file(phylo_data)
	file(phylo_tree)
	file(snpdists)
	file(duplicates_list)
	val(dedup)

        output:
        file("*")
	path "*report.html", emit: report_ch

        script:
        """
	cp $baseDir/bin/core_genome_report_dedup.Rmd .
        Rscript $baseDir/bin/gen_report.R "core_genome" $dedup
        """
}

process REPORT_CORE_GENOME {
        publishDir "${params.out_dir}/results", pattern: "*report.html", mode: "copy"

        label 'shorttime'

        input:
        file(parsnp_report)
        file(phylo_data)
        file(phylo_tree)
        file(snpdists)
	val(dedup)

        output:
        file("*")
        path "*report.html", emit: report_ch

        script:
        """
        cp $baseDir/bin/core_genome_report.Rmd .
        Rscript $baseDir/bin/gen_report.R "core_genome" $dedup
        """
}

process REPORT_CORE_GENE_DEDUP {
        publishDir "${params.out_dir}/results", pattern: "*report.html", mode: "copy"

        label 'shorttime'

        input:
        file(ngenes_list)
        file(ncontigs_list)
        file(mds_data)
        file(pangenome_data)
        file(phylo_data)
        file(phylo_tree)
        file(snpdists)
        file(duplicates_list)
	val(dedup)

        output:
        file("*")
        path "*report.html", emit: report_ch

        script:
        """
        cp $baseDir/bin/core_gene_report_dedup.Rmd .
        Rscript $baseDir/bin/gen_report.R "core_gene" $dedup
        """
}

process REPORT_CORE_GENE {
        publishDir "${params.out_dir}/results", pattern: "*report.html", mode: "copy"

        label 'shorttime'

        input:
        file(ngenes_list)
	file(ncontigs_list)
	file(mds_data)
	file(pangenome_data)
	file(phylo_data)
	file(phylo_tree)
	file(snpdists)
	val(dedup)

        output:
        file("*")
        path "*report.html", emit: report_ch

        script:
        """
	cp $baseDir/bin/core_gene_report.Rmd .
        Rscript $baseDir/bin/gen_report.R "core_gene" $dedup
        """
}

process REPORT_MAPPING_DEDUP {
        publishDir "${params.out_dir}/results", pattern: "*report.html", mode: "copy"

        label 'shorttime'

        input:
        file(snippy_data)
        file(phylo_data)
        file(phylo_tree)
        file(snpdists)
        file(duplicates_list)
	val(dedup)

        output:
        file("*")
        path "*report.html", emit: report_ch

        script:
        """
        cp $baseDir/bin/mapping_report_dedup.Rmd .
        Rscript $baseDir/bin/gen_report.R "mapping" $dedup
        """
}

process REPORT_MAPPING {
        publishDir "${params.out_dir}/results", pattern: "*report.html", mode: "copy"

        label 'shorttime'

        input:
        file(snippy_data)
	file(phylo_data)
	file(phylo_tree)
	file(snpdists)
	val(dedup)

        output:
        file("*")
        path "*report.html", emit: report_ch

        script:
        """
	cp $baseDir/bin/mapping_report.Rmd .
        Rscript $baseDir/bin/gen_report.R "mapping" $dedup
        """
}
