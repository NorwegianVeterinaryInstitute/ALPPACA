process REPORT_CORE_GENOME {
        publishDir "${params.out_dir}/results", pattern: "*report.html", mode: "copy"

	label 'shorttime'

        input:
	file(parsnp_report)
	file(snpdist_report)
	file(seqkit_report)
	file(iqtree_report)
        file(phylo_tree)

        output:
        file("*")
	path "*report.html", emit: report_ch

        script:
        """
	cp $baseDir/bin/core_genome_report.Rmd .
        Rscript $baseDir/bin/gen_report.R "core_genome"
        """
}

process REPORT_CORE_GENE {
        publishDir "${params.out_dir}/results", pattern: "*report.html", mode: "copy"

        label 'shorttime'

        input:
        file(parsnp_report)
        file(snpdist_report)
        file(seqkit_report)
        file(iqtree_report)
        file(phylo_tree)

        output:
        file("*")
        path "*report.html", emit: report_ch

        script:
        """
        Rscript $baseDir/bin/gen_report.R "core_gene"
        """
}

process REPORT_MAPPING {
        publishDir "${params.out_dir}/results", pattern: "*report.html", mode: "copy"

        label 'shorttime'

        input:
        file(parsnp_report)
        file(snpdist_report)
        file(seqkit_report)
        file(iqtree_report)
        file(phylo_tree)

        output:
        file("*")
        path "*report.html", emit: report_ch

        script:
        """
        Rscript $baseDir/bin/gen_report.R "mapping"
        """
}
