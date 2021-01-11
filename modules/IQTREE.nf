process IQTREE {
        conda "/cluster/projects/nn9305k/src/miniconda/envs/IQTree"
        publishDir "${params.out_dir}/logs", pattern: "*.log", mode: "copy"
        publishDir "${params.out_dir}/results", pattern: "*.contree", mode: "copy", saveAs: {"IQTREE_tree.phylo"}
        publishDir "${params.out_dir}/results", pattern: "*.iqtree", mode: "copy", saveAs: {"IQTREE_results.txt"}

        label 'longtime'

        input:
        file(alignment_filtered)

        output:
        file("*")
	path "*.contree", emit: R_tree

        script:
        """
        iqtree -s $alignment_filtered -m $params.iqtree_model -bb $params.bootstrap -nt AUTO -pre iqtree -v $params.outgroup &> iqtree.log
        """
}

