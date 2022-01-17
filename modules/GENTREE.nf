process GENTREE {
        publishDir "${params.out_dir}/results", pattern: "tree.png", mode: "copy", saveAs: {"phylogenetic_tree.png"}
	publishDir "${params.out_dir}/logs", pattern: "gentree.log", mode: "copy"

	label 'shorttime'

        input:
        file(tree)

        output:
        file("*")

        script:
        """
        Rscript $baseDir/bin/gen_tree.R &> gentree.log
        """
}

