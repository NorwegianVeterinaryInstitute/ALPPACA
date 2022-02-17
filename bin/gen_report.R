#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
workflow <- args[1]
dedup_val <- args[2]

# Generate rmarkdown report from ALPPACA run
if (workflow == "core_genome") {
  rmarkdown::render(
    input  = 'core_genome_report.Rmd',
    params = list(
      parsnp_report = "parsnpAligner.log",
      phylo_data = "iqtree.iqtree",
      snpdist_report = "snp_dists.tab",
      seqkit_report = "seqkit_list_duplicated",
      phylo_tree = "iqtree.contree",
      dedup = dedup_val
    )
  )
}

if (workflow == "core_gene") {
  rmarkdown::render(
    input  = 'core_gene_report.Rmd',
    params = list(
      ngenes_data = "ngenes.txt",
      ncontigs_data = "ncontigs.txt",
      pangenome_data = "summary_statistics.txt",
      mds_data = "mds_coords.txt",
      phylo_data = "iqtree.iqtree",
      snpdist_report = "snp_dists.tab",
      seqkit_report = "seqkit_list_duplicated",
      phylo_tree = "iqtree.contree",
      dedup_val = dedup
    )
  )
}

if (workflow == "mapping") {
  rmarkdown::render(
    input  = 'mapping_report.Rmd',
    params = list(
      snippy_report = "core.txt",
      phylo_data = "iqtree.iqtree",
      snpdist_report = "snp_dists.tab",
      seqkit_report = "seqkit_list_duplicated",
      phylo_tree = "iqtree.contree",
      dedup = dedup_val
    )
  )
}
