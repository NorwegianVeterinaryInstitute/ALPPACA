process SNPDIST {
        publishDir "${params.out_dir}/results", pattern: "snp_dists.tab", mode: "copy", saveAs: {"SNPDIST_results.txt"}

        input:
        file(snp_alignment)

        output:
        file("*")
	path "snp_dists.tab", emit: snpdists_results_ch

        script:
        """
        snp-dists $snp_alignment > snp_dists.tab
        """
}

