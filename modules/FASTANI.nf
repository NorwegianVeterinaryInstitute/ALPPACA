process FASTANI {
	conda (params.enable_conda ? 'bioconda::fastani=1.33' : null)
	container 'quay.io/biocontainers/fastani:1.33--h0fdf51a_1'

	label 'process_high_cpu_time'

        input:
        tuple val(id), path(fasta)
	path(refs)

        output:
        path("*")
	path "*_fastani.txt", emit: fastani_ch

        script:
        """
	fastANI --version &> fastani.version
	fastANI -q $fasta\
		--rl $refs\
		-k $params.kmer_size\
		--fragLen $params.fragment_length\
		--minFraction $params.min_fraction\
		--matrix\
		-t $task.cpus\
		-o ${id}_fastani.txt	
        """
}

