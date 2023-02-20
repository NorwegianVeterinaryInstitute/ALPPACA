process PREPARE_TABLE {
        input:
	file(input)

        output:
        file("*")
	path "reflist.txt", emit: reflist_ch

        shell:
        """
	awk -F"," '{print \$2}' $input > reflist.txt
	sed -i '1d' reflist.txt
        """
}

