include { PROKKA } from "${params.module_dir}/PROKKA.nf"
include { PANAROO_QC; PANAROO_PANGENOME } from "${params.module_dir}/PANAROO.nf"
include { DEDUPLICATE } from "${params.module_dir}/SEQKIT.nf"
include { SNPDIST } from "${params.module_dir}/SNPDIST.nf"
include { SNPSITES; SNPSITES_FCONST } from "${params.module_dir}/SNPSITES.nf"
include { IQTREE; IQTREE_FCONST } from "${params.module_dir}/IQTREE.nf"
include { REPORT_CORE_GENE_DEDUP;REPORT_CORE_GENE } from "${params.module_dir}/REPORT.nf"

workflow CORE_GENE {
        assemblies_ch=channel.fromPath(params.assemblies, checkIfExists: true)

        PROKKA(assemblies_ch)
        PANAROO_QC(PROKKA.out.prokka_ch.collect())
        PANAROO_PANGENOME(PROKKA.out.prokka_ch.collect())
        if (params.deduplicate) {
                DEDUPLICATE(PANAROO_PANGENOME.out.core_alignment_ch)
                SNPDIST(DEDUPLICATE.out.seqkit_ch)

                if (params.filter_snps) {
                        SNPSITES(DEDUPLICATE.out.seqkit_ch)
                        SNPSITES_FCONST(DEDUPLICATE.out.seqkit_ch)
                        IQTREE_FCONST(SNPSITES.out.snp_sites_aln_ch,
                                      SNPSITES_FCONST.out.fconst_ch)
                        REPORT_CORE_GENE_DEDUP(PANAROO_QC.out.panaroo_ngenes_ch,
                                               PANAROO_QC.out.panaroo_ncontigs_ch,
                                               PANAROO_QC.out.panaroo_mds_coords_ch,
                                               PANAROO_PANGENOME.out.pangenome_ch,
                                               SNPDIST.out.snpdists_results_ch,
                                               DEDUPLICATE.out.seqkit_duplicated_ch,
                                               IQTREE_FCONST.out.iqtree_results_ch,
                                               IQTREE_FCONST.out.R_tree,
					       params.deduplicate)
                }
                if (!params.filter_snps) {
                        IQTREE(DEDUPLICATE.out.seqkit_ch)
                        REPORT_CORE_GENE_DEDUP(PANAROO_QC.out.panaroo_ngenes_ch,
					       PANAROO_QC.out.panaroo_ncontigs_ch,
					       PANAROO_QC.out.panaroo_mds_coords_ch,
					       PANAROO_PANGENOME.out.pangenome_ch,
					       SNPDIST.out.snpdists_results_ch,
					       DEDUPLICATE.out.seqkit_duplicated_ch,
					       IQTREE.out.iqtree_results_ch,
					       IQTREE.out.R_tree,
					       params.deduplicate)
                }
        }
	if (!params.deduplicate) {
                SNPDIST(PANAROO_PANGENOME.out.core_alignment_ch)
                
		if (params.filter_snps) {
                        SNPSITES(PANAROO_PANGENOME.out.core_alignment_ch)
                        SNPSITES_FCONST(PANAROO_PANGENOME.out.core_alignment_ch)
                        IQTREE_FCONST(SNPSITES.out.snp_sites_aln_ch,
                                      SNPSITES_FCONST.out.fconst_ch)
                        REPORT_CORE_GENE(PANAROO_QC.out.panaroo_ngenes_ch,
                                         PANAROO_QC.out.panaroo_ncontigs_ch,
                                         PANAROO_QC.out.panaroo_mds_coords_ch,
                                         PANAROO_PANGENOME.out.pangenome_ch,
                                         SNPDIST.out.snpdists_results_ch,
                                         IQTREE_FCONST.out.iqtree_results_ch,
                                         IQTREE_FCONST.out.R_tree,
					 params.deduplicate)
                }
                if (!params.filter_snps) {
                        IQTREE(PANAROO_PANGENOME.out.core_alignment_ch)
                        REPORT_CORE_GENE(PANAROO_QC.out.panaroo_ngenes_ch,
                                         PANAROO_QC.out.panaroo_ncontigs_ch,
                                         PANAROO_QC.out.panaroo_mds_coords_ch,
                                         PANAROO_PANGENOME.out.pangenome_ch,
                                         SNPDIST.out.snpdists_results_ch,
                                         IQTREE.out.iqtree_results_ch,
                                         IQTREE.out.R_tree,
					 params.deduplicate)
                }
        }
}

