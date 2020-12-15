process PROKKA {
        conda "/cluster/projects/nn9305k/src/miniconda/envs/bifrost"

        label 'medium'

        input:
        file(assembly)

        output:
        path "*.gff", emit: prokka_ch
        file("*")

        script:
        """
        prokka --addgenes --compliant --prefix $assembly.baseName --cpus $task.cpus --outdir . --force $params.prokka_additional $assembly
        """
}

