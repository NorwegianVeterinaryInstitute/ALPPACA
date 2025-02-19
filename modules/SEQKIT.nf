process DEDUPLICATE {
	conda (params.enable_conda ? 'bioconda::seqkit=2.9:0' : null)
	container 'quay.io/biocontainers/seqkit:2.9.0--h9ee0642_0'

        input:
        file(fasta)

        output:
        file("*")
        path "seqkit_deduplicated.fasta", emit: seqkit_ch
	path "seqkit_list_duplicated", emit: seqkit_duplicated_ch

        script:
        """
	seqkit version > seqkit.version
        seqkit rmdup $fasta -s -D seqkit_list_duplicated -d seqkit_duplicated_seq --alphabet-guess-seq-length 0 --id-ncbi -t dna -w 0 -o seqkit_deduplicated.fasta &> seqkit.log
	
	if [ ! -f seqkit_list_duplicated ]; then touch seqkit_list_duplicated; fi
        """
}

