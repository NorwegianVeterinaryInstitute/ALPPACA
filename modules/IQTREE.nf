process IQTREE {
        container "${params.container_dir}/iqtree:2.1.4_beta--hdcc8f71_0"

        publishDir "${params.out_dir}/logs", pattern: "*.log", mode: "copy"
        publishDir "${params.out_dir}/results", pattern: "*.contree", mode: "copy", saveAs: {"IQTREE_tree.phylo"}
        publishDir "${params.out_dir}/results", pattern: "*.iqtree", mode: "copy", saveAs: {"IQTREE_results.txt"}
	publishDir "${params.out_dir}/results", pattern: "*.alninfo", mode: "copy", saveAs: {"IQTREE_alninfo.txt"}
	publishDir "${params.out_dir}/results", pattern: "*.splits.nex", mode: "copy", saveAs: {"IQTREE_splits.nex"}
	publishDir "${params.out_dir}/results", pattern: "*.ufboot", mode: "copy", saveAs: {"IQTREE_bootstrap_trees.ufboot"}

        label 'longtime'

        input:
        file(alignment_filtered)

        output:
        file("*")
	path "*.contree", emit: R_tree

        script:
        """
        iqtree -s $alignment_filtered\
		-m $params.iqtree_model\
		-bb $params.bootstrap\
		-nt AUTO\
		-pre iqtree\
		-v\
		-alninfo\
		-wbtl\
		$params.outgroup\
		&> iqtree.log
        """
}

process IQTREE_FCONST {
        container "${params.container_dir}/iqtree:2.1.4_beta--hdcc8f71_0"

        publishDir "${params.out_dir}/logs", pattern: "*.log", mode: "copy"
        publishDir "${params.out_dir}/results", pattern: "*.contree", mode: "copy", saveAs: {"IQTREE_tree.phylo"}
        publishDir "${params.out_dir}/results", pattern: "*.iqtree", mode: "copy", saveAs: {"IQTREE_results.txt"}
	publishDir "${params.out_dir}/results", pattern: "*.alninfo", mode: "copy", saveAs: {"IQTREE_alninfo.txt"}
	publishDir "${params.out_dir}/results", pattern: "*.splits.nex", mode: "copy", saveAs: {"IQTREE_splits.nex"}
	publishDir "${params.out_dir}/results", pattern: "*.ufboot", mode: "copy", saveAs: {"IQTREE_bootstrap_trees.ufboot"}

	label 'longtime'

        input:
        file(alignment_filtered)
        val(fconst)

        output:
        file("*")
        path "*.contree", emit: R_tree

        script:
        """
        iqtree -s $alignment_filtered\
		-m $params.iqtree_model\
		-bb $params.bootstrap\
		-nt AUTO\
		-pre iqtree\
		-v\
		-alninfo\
		-wbtl\
		$params.outgroup\
		-fconst $fconst\
		&> iqtree.log
        """
}

