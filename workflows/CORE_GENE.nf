include { PROKKA } from "${params.module_dir}/PROKKA.nf"
include { PANAROO_QC; PANAROO_PANGENOME } from "${params.module_dir}/PANAROO.nf"
include { DEDUPLICATE } from "${params.module_dir}/SEQKIT.nf"
include { SNPDIST } from "${params.module_dir}/SNPDIST.nf"
include { SNPSITES; SNPSITES_FCONST } from "${params.module_dir}/SNPSITES.nf"
include { IQTREE; IQTREE_FCONST } from "${params.module_dir}/IQTREE.nf"
include { GENTREE } from "${params.module_dir}/GENTREE.nf"

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
                        GENTREE(IQTREE_FCONST.out.R_tree)
                }
                if (!params.filter_snps) {
                        IQTREE(DEDUPLICATE.out.seqkit_ch)
                        GENTREE(IQTREE.out.R_tree)
                }
        }
	if (!params.deduplicate) {
                SNPDIST(PANAROO_PANGENOME.out.core_alignment_ch)
                if (params.filter_snps) {
                        SNPSITES(PANAROO_PANGENOME.out.core_alignment_ch)
                        SNPSITES_FCONST(PANAROO_PANGENOME.out.core_alignment_ch)
                        IQTREE_FCONST(SNPSITES.out.snp_sites_aln_ch,
                                      SNPSITES_FCONST.out.fconst_ch)
                        GENTREE(IQTREE_FCONST.out.R_tree)
                }
                if (!params.filter_snps) {
                        IQTREE(PANAROO_PANGENOME.out.core_alignment_ch)
                        GENTREE(IQTREE.out.R_tree)
                }
        }
}

