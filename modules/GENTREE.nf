process GENTREE {
	module 'R/4.0.0-foss-2020a'

        publishDir "${params.out_dir}/results", pattern: "tree.png", mode: "copy", saveAs: {"phylogenetic_tree.png"}

        input:
        file(tree)

        output:
        file("*")

        script:
        """
        Rscript $baseDir/bin/gen_tree.R
        """
}

