process PANAROO_QC {
        publishDir "${params.out_dir}/results", pattern: "*.png", mode: "copy"
        publishDir "${params.out_dir}/results", pattern: "mash_dist.txt", mode: "copy", saveAs: {"PANAROO_mashdist.txt"}
        publishDir "${params.out_dir}/logs", pattern: "panaroo_qc.log", mode: "copy"

	container 'quay.io/biocontainers/panaroo:1.2.9--pyhdfd78af_0'

        label 'process_high_memory_time'

        input:
        file(gffs)

        output:
	path "mds_coords.txt", emit: panaroo_mds_coords_ch
	path "ncontigs.txt", emit: panaroo_ncontigs_ch
	path "ngenes.txt", emit: panaroo_ngenes_ch
	path "mash_contamination_hits.tab", emit: panaroo_mash_ch
        file("*")

        script:
        """
        panaroo-qc -i $gffs -o . -t $task.cpus --graph_type all --ref_db $params.refdb &> panaroo_qc.log
        """
}

process PANAROO_PANGENOME {
        publishDir "${params.out_dir}/results", pattern: "core_gene_alignment.aln", mode: "copy", saveAs: {"PANAROO_core_gene_alignment.aln"}
        publishDir "${params.out_dir}/results", pattern: "summary_statistics.txt", mode: "copy", saveAs: {"PANAROO_pangenome_results.txt"}
        publishDir "${params.out_dir}/logs", pattern: "panaroo_pangenome.log", mode: "copy"

	container 'quay.io/biocontainers/panaroo:1.2.9--pyhdfd78af_0'

        label 'process_high_cpu_time'

        input:
        file(gffs)

        output:
        path "core_gene_alignment.aln", emit: core_alignment_ch
	path "summary_statistics.txt", emit: pangenome_ch
        file("*")

        script:
        """
        panaroo -i $gffs -o . -t $task.cpus -a core --clean-mode $params.clean_mode --aligner mafft &> panaroo_pangenome.log
        """
}

