process PANAROO_QC {
	conda (params.enable_conda ? 'bioconda::panaroo=1.2.9' : null)
	container 'quay.io/biocontainers/panaroo:1.2.9--pyhdfd78af_0'

	label 'process_high_memory_time'

        input:
        file(gffs)
	file(refdb)

        output:
	path "mds_coords.txt", emit: panaroo_mds_coords_ch
	path "ncontigs.txt", emit: panaroo_ncontigs_ch
	path "ngenes.txt", emit: panaroo_ngenes_ch
	path "mash_contamination_hits.tab", emit: panaroo_mash_ch
        file("*")

        script:
        """
        panaroo-qc -i $gffs -o . -t $task.cpus --graph_type all --ref_db $refdb &> panaroo_qc.log
        """
}

process PANAROO_PANGENOME {
	conda (params.enable_conda ? 'bioconda::panaroo=1.2.9' : null)
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
	panaroo --version > panaroo.version
        panaroo -i $gffs -o . -t $task.cpus -a core --clean-mode $params.clean_mode --remove-invalid-genes --aligner mafft --threshold $params.identity_threshold --len_dif_percent $params.len_dif_percent &> panaroo_pangenome.log
        """
}

