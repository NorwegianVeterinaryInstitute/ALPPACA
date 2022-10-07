process PROKKA {
	conda (params.enable_conda ? 'bioconda::prokka=1.14.6' : null)
	container 'quay.io/biocontainers/prokka:1.14.6--pl5262hdfd78af_1'

        input:
        file(assembly)

        output:
        path "*.gff", emit: prokka_ch
        file("*")

        script:
        """
	prokka --version > prokka.version
        prokka --addgenes --compliant --prefix $assembly.baseName --cpus $task.cpus --outdir . --force $params.prokka_additional $assembly
        """
}

