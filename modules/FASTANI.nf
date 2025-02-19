process FASTANI {
	conda (params.enable_conda ? 'bioconda::fastani=1.34' : null)
	container 'quay.io/biocontainers/fastani:1.34--hb66fcc3_5'

	label 'process_high_cpu_time'

        input:
        tuple val(id), path(fasta)
	path(refs)

        output:
        path("*")
	path "*_fastani.txt", emit: fastani_ch

        script:
        """
	fastANI -q $fasta\
		--rl $refs\
		-k $params.kmer_size\
		--fragLen $params.fragment_length\
		--minFraction $params.min_fraction\
		-t $task.cpus\
		-o ${id}_fastani.txt	
        """
}

process FASTANI_VERSION {
        conda (params.enable_conda ? 'bioconda::fastani=1.34' : null)
        container 'quay.io/biocontainers/fastani:1.34--hb66fcc3_5'

        script:
        """
        fastANI --version &> fastani.version
        """
}


