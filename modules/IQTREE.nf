process IQTREE {
	conda (params.enable_conda ? 'bioconda::iqtree=2.2.0.3' : null)
	container 'quay.io/biocontainers/iqtree:2.2.0.3--hb97b32f_0'

	label 'process_long'

        input:
        file(alignment_filtered)

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
		$params.outgroup
        """
}

process IQTREE_FCONST {
	conda (params.enable_conda ? 'bioconda::iqtree=2.2.0.3'' : null)
	container 'quay.io/biocontainers/iqtree:2.2.0.3--hb97b32f_0'

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
               $params.outgroup\
               -fconst $fconst
       """
}

