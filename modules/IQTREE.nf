process IQTREE {
        publishDir "${params.out_dir}/logs", pattern: "*.log", mode: "copy"
        publishDir "${params.out_dir}/results", pattern: "*.contree", mode: "copy", saveAs: {"IQTREE_tree.phylo"}
        publishDir "${params.out_dir}/results", pattern: "*.iqtree", mode: "copy", saveAs: {"IQTREE_results.txt"}
	publishDir "${params.out_dir}/results", pattern: "*.alninfo", mode: "copy", saveAs: {"IQTREE_alninfo.txt"}
	publishDir "${params.out_dir}/results", pattern: "*.splits.nex", mode: "copy", saveAs: {"IQTREE_splits.nex"}
	publishDir "${params.out_dir}/results", pattern: "*.ufboot", mode: "copy", saveAs: {"IQTREE_bootstrap_trees.ufboot"}
	publishDir "${params.out_dir}/results", pattern: "*.treefile", mode: "copy", saveAs: {"IQTREE_ml_tree.phylo"}

        label 'longtime'

        input:
        file(alignment_filtered)

        output:
        file("*")
	path "*.contree", emit: R_tree
	path "iqtree.iqtree", emit: iqtree_results_ch

        script:
        """
        iqtree -s $alignment_filtered\
		-m $params.iqtree_model\
		-mset $params.mset\
                -cmax $params.cmax\
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
        publishDir "${params.out_dir}/logs", pattern: "*.log", mode: "copy"
        publishDir "${params.out_dir}/results", pattern: "*.contree", mode: "copy", saveAs: {"IQTREE_tree.phylo"}
        publishDir "${params.out_dir}/results", pattern: "*.iqtree", mode: "copy", saveAs: {"IQTREE_results.txt"}
	publishDir "${params.out_dir}/results", pattern: "*.alninfo", mode: "copy", saveAs: {"IQTREE_alninfo.txt"}
	publishDir "${params.out_dir}/results", pattern: "*.splits.nex", mode: "copy", saveAs: {"IQTREE_splits.nex"}
	publishDir "${params.out_dir}/results", pattern: "*.ufboot", mode: "copy", saveAs: {"IQTREE_bootstrap_trees.ufboot"}
	publishDir "${params.out_dir}/results", pattern: "*.treefile", mode: "copy", saveAs: {"IQTREE_ml_tree.phylo"}

	label 'longtime'

        input:
        file(alignment_filtered)
        val(fconst)

        output:
        file("*")
        path "*.contree", emit: R_tree
	path "iqtree.iqtree", emit: iqtree_results_ch

        script:
        if (params.test)
		"""
        	iqtree -s $alignment_filtered\
			-m $params.iqtree_model\
			-mset $params.mset\
			-cmax $params.cmax\
			-bb $params.bootstrap\
			-nt AUTO\
			-pre iqtree\
			-v\
			-alninfo\
			-wbtl\
			$params.outgroup\
			-fconst $fconst\
			-seed 1234\
			&> iqtree.log
        	"""
	else
		"""
                iqtree -s $alignment_filtered\
                        -m $params.iqtree_model\
                        -mset $params.mset\
                        -cmax $params.cmax\
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

