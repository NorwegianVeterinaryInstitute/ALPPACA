process BAKTA {
	conda (params.enable_conda ? 'bioconda::bakta=1.9.1' : null)
	container 'evezeyl/bakta:1.9.1'

	label 'process_medium_memory'

        input:
        file(assembly)
	path db

        output:
        path "*.gff3", emit: bakta_ch
        file("*")

        script:
        """
        bakta --version > bakta.version
        bakta --db $db --skip-plot --prefix $assembly.baseName --threads $task.cpus $assembly
        """
}
