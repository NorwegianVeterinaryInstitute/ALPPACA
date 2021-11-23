process SNPDIST {
        container "${params.container_dir}/snp-dists:0.8.2--h5bf99c6_0"

        publishDir "${params.out_dir}/results", pattern: "snp_dists.tab", mode: "copy", saveAs: {"SNPDIST_results.txt"}

        input:
        file(snp_alignment)

        output:
        file("*")

        script:
        """
        snp-dists $snp_alignment > snp_dists.tab
        """
}

