// ALPPACA Pipeline


log.info "=========================================================="
log.info "||                     A-L-P-P-A-C-A                    ||"
log.info "=========================================================="
log.info "                   Run track: $params.type                "
log.info "                                                          "
log.info "=========================================================="

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
        IQTREE(MASKRC.out.masked_ch)
	GENTREE(IQTREE.out.R_tree)
}

workflow PARSNP_PHYLO {
        assemblies_ch=channel.fromPath(params.assemblies, checkIfExists: true)
                             .collect()

        PARSNP(assemblies_ch)
        CONVERT(PARSNP.out.xmfa_ch)
        if (params.deduplicate) {
                DEDUPLICATE(CONVERT.out.fasta_alignment_ch)
                GUBBINS(DEDUPLICATE.out.seqkit_ch)
                MASKRC(GUBBINS.out.gubbins_ch,
                       DEDUPLICATE.out.seqkit_ch)
        }
        if (!params.deduplicate) {
                GUBBINS(CONVERT.out.fasta_alignment_ch)
                MASKRC(GUBBINS.out.gubbins_ch,
                       CONVERT.out.fasta_alignment_ch)
        }
        SNPDIST(MASKRC.out.masked_ch)
        IQTREE(MASKRC.out.masked_ch)
	GENTREE(IQTREE.out.R_tree)
}

workflow CORE_PHYLO {
        assemblies_ch=channel.fromPath(params.assemblies, checkIfExists: true)

        PROKKA(assemblies_ch)
        PANAROO_QC(PROKKA.out.prokka_ch.collect())
        PANAROO_PANGENOME(PROKKA.out.prokka_ch.collect())
        if (params.deduplicate) {
                DEDUPLICATE(PANAROO_PANGENOME.out.core_alignment_ch)
                SNPDIST(DEDUPLICATE.out.seqkit_ch)
                IQTREE(DEDUPLICATE.out.seqkit_ch)
        }
        if (!params.deduplicate) {
                SNPDIST(PANAROO_PANGENOME.out.core_alignment_ch)
                IQTREE(PANAROO_PANGENOME.out.core_alignment_ch)
        }
	GENTREE(IQTREE.out.R_tree)
}

workflow {
if (params.type == "reads") {
	include { SNIPPY } from "${params.module_dir}/SNIPPY.nf"
        include { DEDUPLICATE } from "${params.module_dir}/SEQKIT.nf"
        include { GUBBINS } from "${params.module_dir}/GUBBINS.nf"
        include { MASKRC } from "${params.module_dir}/MASKRC.nf"
        include { SNPDIST } from "${params.module_dir}/SNPDIST.nf"
        include { IQTREE } from "${params.module_dir}/IQTREE.nf"
	include { GENTREE } from "${params.module_dir}/GENTREE.nf"
	
	SNIPPY_PHYLO()
	}

if (params.type == "assembly") {
include { PARSNP } from "${params.module_dir}/PARSNP.nf"
        include { CONVERT } from "${params.module_dir}/HARVESTTOOLS.nf"
        include { DEDUPLICATE } from "${params.module_dir}/SEQKIT.nf"
        include { GUBBINS } from "${params.module_dir}/GUBBINS.nf"
        include { MASKRC } from "${params.module_dir}/MASKRC.nf"
        include { SNPDIST } from "${params.module_dir}/SNPDIST.nf"
        include { IQTREE } from "${params.module_dir}/IQTREE.nf"
	include { GENTREE } from "${params.module_dir}/GENTREE.nf"	
	
	PARSNP_PHYLO()
	}

if (params.type == "core") {
	include { PROKKA } from "${params.module_dir}/PROKKA.nf"
        include { PANAROO_QC; PANAROO_PANGENOME } from "${params.module_dir}/PANAROO.nf"
        include { DEDUPLICATE } from "${params.module_dir}/SEQKIT.nf"
        include { SNPDIST } from "${params.module_dir}/SNPDIST.nf"
        include { IQTREE } from "${params.module_dir}/IQTREE.nf"
	include { GENTREE } from "${params.module_dir}/GENTREE.nf"	
	
	CORE_PHYLO()
	}
}
