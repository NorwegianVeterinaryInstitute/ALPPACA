process BAKTA {
	conda (params.enable_conda ? 'bioconda::bakta=1.9.1' : null)
	container 'evezeyl/bakta:1.9.1'

        input:
        file(assembly)

        output:
        path "*.gff", emit: bakta_ch
        file("*")

        script:
        """
	bakta --version > bakta.version
        bakta --db /bakta_db/db --skip-plot --prefix $assembly.baseName --cpus $task.cpus $assembly
        """
}
