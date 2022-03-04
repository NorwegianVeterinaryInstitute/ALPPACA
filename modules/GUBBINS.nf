process GUBBINS {
        publishDir "${params.out_dir}/logs", pattern: "gubbins.log", mode: "copy"
        publishDir "${params.out_dir}/results", pattern: "*filtered_polymorphic_sites.fasta", mode: "copy", saveAs: {"GUBBINS_filtered_alignment.aln"}
        publishDir "${params.out_dir}/results", pattern: "*per_branch_statistics.csv", mode: "copy", saveAs: {"GUBBINS_statistics.txt"}

	label 'bigmem_gubbins'

        input:
        file(alignment)

        output:
        path "*filtered_polymorphic_sites.fasta", emit: filtered_alignment_ch
        path "*", emit: gubbins_ch

        script:
        """
        run_gubbins.py $alignment --tree-builder $params.treebuilder --model $params.gubbinsmodel --threads $task.cpus -v --prefix gubbins_out &> gubbins.log
        """
}
