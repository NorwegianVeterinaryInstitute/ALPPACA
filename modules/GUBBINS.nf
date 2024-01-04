process GUBBINS {
	conda (params.enable_conda ? 'bioconda::gubbins=3.2.0' : null)
	container 'evezeyl/gubbins:3.3.2'

	label 'process_high_memory_time'

        input:
        file(alignment)

        output:
        path "*filtered_polymorphic_sites.fasta", emit: filtered_alignment_ch
        path "*", emit: gubbins_ch

        script:
        """
	run_gubbins.py --version > gubbins.version
        run_gubbins.py $alignment --seed $params.seed --tree-builder $params.treebuilder --model $params.gubbinsmodel --threads $task.cpus -v --prefix gubbins_out &> gubbins.log
        """
}
