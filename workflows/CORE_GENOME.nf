include { DEDUPLICATE                } from "../modules/SEQKIT.nf"
include { GUBBINS                    } from "../modules/GUBBINS.nf"
include { MASKRC                     } from "../modules/MASKRC.nf"
include { SNPDIST                    } from "../modules/SNPDIST.nf"
include { SNPSITES; SNPSITES_FCONST  } from "../modules/SNPSITES.nf"
include { IQTREE_FCONST; IQTREE_FAST } from "../modules/IQTREE.nf"
include { REPORT_CORE_GENOME         } from "../modules/REPORT.nf"
include { PARSNP                     } from "../modules/PARSNP.nf"

workflow CORE_GENOME {
	 if (!params.input) {
                exit 1, "Missing input file"
        }

	assemblies_ch = Channel
		.fromPath(params.input, checkIfExists: true)
		.splitCsv(header:true, sep:",")
		.map { file(it.path, checkIfExists: true) }
		.collect()

        PARSNP(assemblies_ch)

        if (params.deduplicate) {
                DEDUPLICATE(PARSNP.out.fasta_alignment_ch)
                GUBBINS(DEDUPLICATE.out.seqkit_ch)
                MASKRC(GUBBINS.out.gubbins_ch,
                       DEDUPLICATE.out.seqkit_ch)
		SNPDIST(MASKRC.out.masked_ch)
		SNPSITES(MASKRC.out.masked_ch)
                SNPSITES_FCONST(MASKRC.out.masked_ch)

		if (params.fast_mode) {
                	IQTREE_FAST(SNPSITES.out.snp_sites_aln_ch,
                        	    SNPSITES_FCONST.out.fconst_ch)
                	REPORT_CORE_GENOME(PARSNP.out.parsnp_results_ch,
                                           SNPDIST.out.snpdists_results_ch,
			       		   IQTREE_FAST.out.iqtree_results_ch,
                               		   IQTREE_FAST.out.R_tree)
		}
		if (!params.fast_mode) {
                        IQTREE_FCONST(SNPSITES.out.snp_sites_aln_ch,
                                      SNPSITES_FCONST.out.fconst_ch)
                        REPORT_CORE_GENOME(PARSNP.out.parsnp_results_ch,
                               		   SNPDIST.out.snpdists_results_ch,
                               		   IQTREE_FCONST.out.iqtree_results_ch,
                               		   IQTREE_FCONST.out.R_tree)
                }
        }

        if (!params.deduplicate) {
                GUBBINS(PARSNP.out.fasta_alignment_ch)
                MASKRC(GUBBINS.out.gubbins_ch,
                       PARSNP.out.fasta_alignment_ch)
		SNPDIST(MASKRC.out.masked_ch)
		SNPSITES(MASKRC.out.masked_ch)
                SNPSITES_FCONST(MASKRC.out.masked_ch)

		if (params.fast_mode) {
                        IQTREE_FAST(SNPSITES.out.snp_sites_aln_ch,
                                    SNPSITES_FCONST.out.fconst_ch)
                        REPORT_CORE_GENOME(PARSNP.out.parsnp_results_ch,
                               		   SNPDIST.out.snpdists_results_ch,
                               		   IQTREE_FAST.out.iqtree_results_ch,
                               		   IQTREE_FAST.out.R_tree)
                }
		if (!params.fast_mode) {
			IQTREE_FCONST(SNPSITES.out.snp_sites_aln_ch,
                                      SNPSITES_FCONST.out.fconst_ch)
                	REPORT_CORE_GENOME(PARSNP.out.parsnp_results_ch,
                               		   SNPDIST.out.snpdists_results_ch,
                               		   IQTREE_FCONST.out.iqtree_results_ch,
                               		   IQTREE_FCONST.out.R_tree)
		}
        }
}

