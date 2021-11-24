// ALPPACA Pipeline


log.info "============================================================="
log.info ".          -------------------------------                  ."
log.info ".          |                             |                  ."
log.info ".   ----------------               -------------            ."
log.info ".   |              |               |           |            ."
log.info ".-------     -------------         |     ------------       ."
log.info ".|     |     |           |         |     |          |       ."
log.info ".A     L     P           P         A     C          A       ."
log.info ".A  tooL for Prokaryotic Phylogeny And   Clustering Analysis."
log.info "============================================================="
log.info " Run track: $params.type                                     "
log.info " ALPPACA Version: 1.0.0                                      "
log.info "=============================================================".stripIndent()

// Activate dsl2
nextflow.enable.dsl=2

// Define workflows
workflow SNIPPY_PHYLO {
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

workflow PARSNP_PHYLO {
        assemblies_ch=channel.fromPath(params.assemblies, checkIfExists: true)
                             .collect()

        PARSNP(assemblies_ch)
        if (params.deduplicate) {
                DEDUPLICATE(PARSNP.out.fasta_alignment_ch)
                GUBBINS(DEDUPLICATE.out.seqkit_ch)
                MASKRC(GUBBINS.out.gubbins_ch,
                       DEDUPLICATE.out.seqkit_ch)
        }
        if (!params.deduplicate) {
                GUBBINS(PARSNP.out.fasta_alignment_ch)
                MASKRC(GUBBINS.out.gubbins_ch,
                       CONVERT.out.fasta_alignment_ch)
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

workflow CORE_PHYLO {
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

workflow {
if (params.type == "mapping") {
	include { SNIPPY } from "${params.module_dir}/SNIPPY.nf"
        include { DEDUPLICATE } from "${params.module_dir}/SEQKIT.nf"
        include { GUBBINS } from "${params.module_dir}/GUBBINS.nf"
        include { MASKRC } from "${params.module_dir}/MASKRC.nf"
        include { SNPDIST } from "${params.module_dir}/SNPDIST.nf"
        include { SNPSITES } from "${params.module_dir}/SNPSITES.nf"
        include { SNPSITES_FCONST } from "${params.module_dir}/SNPSITES.nf"
        include { IQTREE } from "${params.module_dir}/IQTREE.nf"
        include { IQTREE_FCONST } from "${params.module_dir}/IQTREE.nf"
	include { GENTREE } from "${params.module_dir}/GENTREE.nf"
	
	SNIPPY_PHYLO()
	}

if (params.type == "core_genome") {
	include { PARSNP } from "${params.module_dir}/PARSNP.nf"
        include { DEDUPLICATE } from "${params.module_dir}/SEQKIT.nf"
        include { GUBBINS } from "${params.module_dir}/GUBBINS.nf"
        include { MASKRC } from "${params.module_dir}/MASKRC.nf"
        include { SNPDIST } from "${params.module_dir}/SNPDIST.nf"
	include { SNPSITES } from "${params.module_dir}/SNPSITES.nf"
        include { SNPSITES_FCONST } from "${params.module_dir}/SNPSITES.nf"
	include { IQTREE } from "${params.module_dir}/IQTREE.nf"
	include { IQTREE_FCONST } from "${params.module_dir}/IQTREE.nf"
	include { GENTREE } from "${params.module_dir}/GENTREE.nf"	
	
	PARSNP_PHYLO()
	}

if (params.type == "core_gene") {
	include { PROKKA } from "${params.module_dir}/PROKKA.nf"
        include { PANAROO_QC; PANAROO_PANGENOME } from "${params.module_dir}/PANAROO.nf"
        include { DEDUPLICATE } from "${params.module_dir}/SEQKIT.nf"
        include { SNPDIST } from "${params.module_dir}/SNPDIST.nf"
        include { SNPSITES } from "${params.module_dir}/SNPSITES.nf"
        include { SNPSITES_FCONST } from "${params.module_dir}/SNPSITES.nf"
        include { IQTREE } from "${params.module_dir}/IQTREE.nf"
        include { IQTREE_FCONST } from "${params.module_dir}/IQTREE.nf"
	include { GENTREE } from "${params.module_dir}/GENTREE.nf"	
	
	CORE_PHYLO()
	}
}
