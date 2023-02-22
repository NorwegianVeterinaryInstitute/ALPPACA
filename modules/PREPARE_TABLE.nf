process PREPARE_TABLE {
        input:
	file(input)

        output:
        file("*")
	path "reflist.txt", emit: reflist_ch

        shell:
        """
	readlink -f *fasta > reflist.txt
        """
}

