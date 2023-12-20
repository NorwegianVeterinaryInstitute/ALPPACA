process IQTREE_FCONST {
	conda (params.enable_conda ? 'bioconda::iqtree=2.2.6' : null)
	container 'quay.io/biocontainers/iqtree:2.2.6--h21ec9f0_0'

	label 'process_long'

        input:
        file(alignment_filtered)
        val(fconst)

        output:
        file("*")
        path "*.contree", emit: R_tree
	path "iqtree.iqtree", emit: iqtree_results_ch

        script:
	"""
	iqtree --version > iqtree.version
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
	       -seed $params.seed\
               $params.outgroup\
               -fconst $fconst
       """
}

process IQTREE_FAST {
        conda (params.enable_conda ? 'bioconda::iqtree=2.2.6' : null)
        container 'quay.io/biocontainers/iqtree:2.2.6--h21ec9f0_0'

        label 'process_long'

        input:
        file(alignment_filtered)
        val(fconst)

        output:
        file("*")
        path "*.treefile", emit: R_tree
        path "iqtree.iqtree", emit: iqtree_results_ch

        script:
        """
        iqtree --version > iqtree.version
        iqtree -s $alignment_filtered\
               -m $params.iqtree_model\
               -mset $params.mset\
               -cmax $params.cmax\
	       -fast\
	       -safe\
               -alrt $params.bootstrap\
               -nt AUTO\
               -pre iqtree\
               -v\
               -alninfo\
               -wbtl\
               -seed $params.seed\
               $params.outgroup\
               -fconst $fconst
       """
}
