include { PROKKA                        } from "../modules/PROKKA.nf"
include { PANAROO_QC; PANAROO_PANGENOME } from "../modules/PANAROO.nf"
include { DEDUPLICATE                   } from "../modules/SEQKIT.nf"
include { SNPDIST                       } from "../modules/SNPDIST.nf"
include { SNPSITES; SNPSITES_FCONST     } from "../modules/SNPSITES.nf"
include { IQTREE_FCONST; IQTREE_FAST    } from "../modules/IQTREE.nf"
include { REPORT_CORE_GENE		} from "../modules/REPORT.nf"

workflow CORE_GENE {
	 if (!params.input) {
                exit 1, "Missing input file"
        }

	assemblies_ch = Channel
		.fromPath(params.input, checkIfExists: true)
		.splitCsv(header:true, sep:",")
		.map { file(it.path, checkIfExists: true) }

        PROKKA(assemblies_ch)

	if (params.qc) {
		refdb_ch = Channel
                	.fromPath(params.refdb)

        	PANAROO_QC(PROKKA.out.prokka_ch.collect(),
		   	   refdb_ch)
	}

        PANAROO_PANGENOME(PROKKA.out.prokka_ch.collect())
        if (params.deduplicate) {
                DEDUPLICATE(PANAROO_PANGENOME.out.core_alignment_ch)
                SNPDIST(DEDUPLICATE.out.seqkit_ch)
		SNPSITES(DEDUPLICATE.out.seqkit_ch)
                SNPSITES_FCONST(DEDUPLICATE.out.seqkit_ch)
	
                if (params.fast_mode) {
                        IQTREE_FAST(SNPSITES.out.snp_sites_aln_ch,
                                    SNPSITES_FCONST.out.fconst_ch)
                        REPORT_CORE_GENE(PANAROO_PANGENOME.out.pangenome_ch,
					 SNPDIST.out.snpdists_results_ch,
					 IQTREE_FAST.out.iqtree_results_ch,
					 IQTREE_FAST.out.R_tree)
                }
                if (!params.fast_mode) {
                        IQTREE_FCONST(SNPSITES.out.snp_sites_aln_ch,
                                      SNPSITES_FCONST.out.fconst_ch)
                        REPORT_CORE_GENE(PANAROO_PANGENOME.out.pangenome_ch,
			       		 SNPDIST.out.snpdists_results_ch,
			       		 IQTREE_FCONST.out.iqtree_results_ch,
			       		 IQTREE_FCONST.out.R_tree)
                }
        }
	if (!params.deduplicate) {
                SNPDIST(PANAROO_PANGENOME.out.core_alignment_ch)
		SNPSITES(PANAROO_PANGENOME.out.core_alignment_ch)
                SNPSITES_FCONST(PANAROO_PANGENOME.out.core_alignment_ch)                

		if (params.fast_mode) {
                        IQTREE_FAST(SNPSITES.out.snp_sites_aln_ch,
                                    SNPSITES_FCONST.out.fconst_ch)
                        REPORT_CORE_GENE(PANAROO_PANGENOME.out.pangenome_ch,
                               		 SNPDIST.out.snpdists_results_ch,
                               		 IQTREE_FAST.out.iqtree_results_ch,
                               		 IQTREE_FAST.out.R_tree)
                }
                if (!params.fast_mode) {
                        IQTREE_FCONST(SNPSITES.out.snp_sites_aln_ch,
                                      SNPSITES_FCONST.out.fconst_ch)
                        REPORT_CORE_GENE(PANAROO_PANGENOME.out.pangenome_ch,
                               		 SNPDIST.out.snpdists_results_ch,
                               		 IQTREE_FCONST.out.iqtree_results_ch,
                               		 IQTREE_FCONST.out.R_tree)
                }
        }
}

