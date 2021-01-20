process SNPSITES_FCONST {
        conda "/cluster/projects/nn9305k/src/miniconda/envs/snp-sites"

	label 'shorttime'

        input:
        file(snp_alignment)

        output:
        stdout emit: fconst_ch

        shell:
        '''
        fconst_val=`snp-sites -C !{snp_alignment}`
	echo -n $fconst_val
        '''
}

process SNPSITES {
        conda "/cluster/projects/nn9305k/src/miniconda/envs/snp-sites"

	publishDir "${params.out_dir}/results", pattern: "snp_sites_alignment.aln", mode: "copy", saveAs: {"SNP_sites_alignment.aln"}
	publishDir "${params.out_dir}/logs", pattern: "snp_sites.log", mode: "copy"

	label 'shorttime'

        input:
        file(snp_alignment)

        output:
        path "snp_sites_alignment*", emit: snp_sites_aln_ch

        script:
        """
        snp-sites -m -o snp_sites_alignment.aln $snp_alignment &> snp_sites.log
        """
}

