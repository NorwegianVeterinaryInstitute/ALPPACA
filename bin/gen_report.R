#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
workflow <- args[1]

# Generate rmarkdown report from ALPPACA run
if (workflow == "core_genome") {
  rmarkdown::render(
    input  = 'core_genome_report.Rmd',
    params = list(
      parsnp_report = "parsnpAligner.log",
      phylo_data = "iqtree.iqtree",
      snpdist_report = "snp_dists.tab",
      seqkit_report = "seqkit_list_duplicated",
      phylo_tree = "iqtree.contree"
    )
  )
}

if (workflow == "core_gene") {
  rmarkdown::render(
    input  = 'core_gene_report.Rmd',
    params = list(
      ngenes_data = "../testdata/ngenes.txt",
      ncontigs_data = "../testdata/ncontigs.txt",
      pangenome_data = "../testdata/PANAROO_pangenome_results.txt",
      mds_data = "../testdata/mds_coords.txt",
      phylo_data = "../testdata/IQTree_results.txt",
      snpdist_report = "../testdata/SNPDIST_results.txt",
      seqkit_report = "../testdata/SEQKIT_duplicated_list.txt",
      phylo_tree = "../testdata/IQTREE_tree.phylo"
    )
  )
}

if (workflow == "mapping") {
  rmarkdown::render(
    input  = 'mapping_report.Rmd',
    params = list(
      snippy_report = "../testdata/SNIPPY_results.txt",
      phylo_data = "../testdata/IQTree_results.txt",
      snpdist_report = "../testdata/SNPDIST_results.txt",
      seqkit_report = "../testdata/SEQKIT_duplicated_list.txt",
      phylo_tree = "../testdata/IQTREE_tree.phylo"
    )
  )
}
