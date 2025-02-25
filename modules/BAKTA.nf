process BAKTA {
	conda (params.enable_conda ? 'bioconda::bakta=1.10.4' : null)
	container 'evezeyl/bakta:1.10.4'

	label 'process_medium_memory'

        input:
        path assembly

        output:
        path "*.gff3", emit: bakta_ch
        file("*")

        script:

	def db_path = "/bakta_db/db" ?: params.bakta_db

        """
        bakta --version > bakta.version
        bakta --db $db_path --skip-plot --prefix $assembly.baseName --threads $task.cpus $assembly
        """
}
