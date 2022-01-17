process PANAROO_QC {
        publishDir "${params.out_dir}/results", pattern: "*.png", mode: "copy"
        publishDir "${params.out_dir}/results", pattern: "mash_dist.txt", mode: "copy", saveAs: {"PANAROO_mashdist.txt"}
        publishDir "${params.out_dir}/logs", pattern: "panaroo_qc.log", mode: "copy"

        label 'bigmem'

        input:
        file(gffs)

        output:
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

        label 'heavy'

        input:
        file(gffs)

        output:
        path "core_gene_alignment.aln", emit: core_alignment_ch
        file("*")

        script:
        """
        panaroo -i $gffs -o . -t $task.cpus -a core --clean-mode $params.clean_mode --aligner mafft &> panaroo_pangenome.log
        """
}

