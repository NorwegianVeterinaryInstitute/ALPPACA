include { SNIPPY } from "${params.module_dir}/SNIPPY.nf"
include { DEDUPLICATE } from "${params.module_dir}/SEQKIT.nf"
include { GUBBINS } from "${params.module_dir}/GUBBINS.nf"
include { MASKRC } from "${params.module_dir}/MASKRC.nf"
include { SNPDIST } from "${params.module_dir}/SNPDIST.nf"
include { SNPSITES; SNPSITES_FCONST } from "${params.module_dir}/SNPSITES.nf"
include { IQTREE; IQTREE_FCONST } from "${params.module_dir}/IQTREE.nf"
include { GENTREE } from "${params.module_dir}/GENTREE.nf"


workflow MAPPING {
        reads_ch=channel.fromPath(params.reads, checkIfExists: true)
                        .collect()

        SNIPPY(reads_ch)
        if (params.deduplicate) {
                DEDUPLICATE(SNIPPY.out.snippy_alignment_ch)
                GUBBINS(DEDUPLICATE.out.seqkit_ch)
                MASKRC(GUBBINS.out.gubbins_ch,
                       DEDUPLICATE.out.seqkit_ch)
        }
        if (!params.deduplicate) {
                GUBBINS(SNIPPY.out.snippy_alignment_ch)
                MASKRC(GUBBINS.out.gubbins_ch,
                       SNIPPY.out.snippy_alignment_ch)
        }
        SNPDIST(MASKRC.out.masked_ch)

        if (params.filter_snps) {
                SNPSITES(MASKRC.out.masked_ch)
                SNPSITES_FCONST(MASKRC.out.masked_ch)
                IQTREE_FCONST(SNPSITES.out.snp_sites_aln_ch,
                              SNPSITES_FCONST.out.fconst_ch)
                GENTREE(IQTREE_FCONST.out.R_tree)
        }
        if (!params.filter_snps) {
                IQTREE(MASKRC.out.masked_ch)
                GENTREE(IQTREE.out.R_tree)
        }
}
