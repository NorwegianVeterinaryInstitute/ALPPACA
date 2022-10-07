process SNIPPY {
	conda (params.enable_conda ? 'bioconda::snippy=4.6.0' : null)
	container 'quay.io/biocontainers/snippy:4.6.0--hdfd78af_1'

	label 'process_high_cpu_time'

        input:
        file("*")

        output:
        path "core.full.aln", emit: snippy_alignment_ch
	path "core.txt", emit: results_ch
        file("*")

        script:
        """
        snippy --version > snippy.version
	$baseDir/bin/snippyfy.bash "$params.R1" "$params.R2" "$params.suffix"
        snippy-multi snippy_samples.list --ref $params.snippyref --cpus $task.cpus > snippy.sh
        sh snippy.sh &> snippy.log
        """
}

