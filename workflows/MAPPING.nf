include { SNIPPY } from "${params.module_dir}/SNIPPY.nf"
include { DEDUPLICATE } from "${params.module_dir}/SEQKIT.nf"
include { GUBBINS } from "${params.module_dir}/GUBBINS.nf"
include { MASKRC } from "${params.module_dir}/MASKRC.nf"
include { SNPDIST } from "${params.module_dir}/SNPDIST.nf"
include { SNPSITES; SNPSITES_FCONST } from "${params.module_dir}/SNPSITES.nf"
include { IQTREE; IQTREE_FCONST } from "${params.module_dir}/IQTREE.nf"
include { REPORT_MAPPING_DEDUP;REPORT_MAPPING } from "${params.module_dir}/REPORT.nf"


workflow MAPPING {
        reads_ch=channel.fromPath(params.reads, checkIfExists: true)
                        .collect()

        SNIPPY(reads_ch)

        if (params.deduplicate) {
                DEDUPLICATE(SNIPPY.out.snippy_alignment_ch)
                GUBBINS(DEDUPLICATE.out.seqkit_ch)
                MASKRC(GUBBINS.out.gubbins_ch,
                       DEDUPLICATE.out.seqkit_ch)
		SNPDIST(MASKRC.out.masked_ch)

		if (params.filter_snps) {
                	SNPSITES(MASKRC.out.masked_ch)
                	SNPSITES_FCONST(MASKRC.out.masked_ch)
                	IQTREE_FCONST(SNPSITES.out.snp_sites_aln_ch,
                        	      SNPSITES_FCONST.out.fconst_ch)
                	REPORT_MAPPING_DEDUP(SNIPPY.out.results_ch,
                        	       	     SNPDIST.out.snpdists_results_ch,
                               	             DEDUPLICATE.out.seqkit_duplicated_ch,
                               	             IQTREE_FCONST.out.iqtree_results_ch,
                               	             IQTREE_FCONST.out.R_tree,
					     params.deduplicate)
        	}
		if (!params.filter_snps) {
                	IQTREE(MASKRC.out.masked_ch)
                	REPORT_MAPPING_DEDUP(SNIPPY.out.results_ch,
                                       	     SNPDIST.out.snpdists_results_ch,
                               	             DEDUPLICATE.out.seqkit_duplicated_ch,
                               	             IQTREE.out.iqtree_results_ch,
                               	             IQTREE.out.R_tree,
					     params.deduplicate)
        	}
        }

        if (!params.deduplicate) {
                GUBBINS(SNIPPY.out.snippy_alignment_ch)
                MASKRC(GUBBINS.out.gubbins_ch,
                       SNIPPY.out.snippy_alignment_ch)
		SNPDIST(MASKRC.out.masked_ch)

		if (params.filter_snps) {
                	SNPSITES(MASKRC.out.masked_ch)
                        SNPSITES_FCONST(MASKRC.out.masked_ch)
                        IQTREE_FCONST(SNPSITES.out.snp_sites_aln_ch,
                               	      SNPSITES_FCONST.out.fconst_ch)
                        REPORT_MAPPING(SNIPPY.out.results_ch,
                               	       SNPDIST.out.snpdists_results_ch,
	                               IQTREE_FCONST.out.iqtree_results_ch,
        	                       IQTREE_FCONST.out.R_tree,
                	               params.deduplicate)
                }
                if (!params.filter_snps) {
                        IQTREE(MASKRC.out.masked_ch)
                        REPORT_MAPPING(SNIPPY.out.results_ch,
                                       SNPDIST.out.snpdists_results_ch,
                                       IQTREE.out.iqtree_results_ch,
                                       IQTREE.out.R_tree,
                                       params.deduplicate)
                }
        }
}
