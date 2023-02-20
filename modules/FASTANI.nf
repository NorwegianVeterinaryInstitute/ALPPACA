process FASTANI {
	conda (params.enable_conda ? 'bioconda::fastani-1.32' : null)
	container 'quay.io/biocontainers/fastani:1.33--h0fdf51a_1'

	label 'process_high_cpu_time'

        input:
        tuple val(id), path(fasta)
	file(reflist)

        output:
        file("*")
	path "*_fastani.txt", emit: fastani_ch

        script:
        """
	fastANI --version > fastani.version
	fastANI -q $fasta --rl $reflist -o ${id}_fastani.txt	
        """
}

