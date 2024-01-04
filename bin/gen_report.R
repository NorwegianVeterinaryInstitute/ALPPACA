#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
workflow <- args[1]

# Generate rmarkdown report from ALPPACA run
if (workflow == "ani") {
    rmarkdown::render(
      input  = 'ani_report.Rmd',
      params = list(
        ani_data = "FASTANI_results.txt"
      )
    )
}

if (workflow == "cgmlst") {
    rmarkdown::render(
      input  = 'cgmlst_report.Rmd',
      params = list(
        allelecall_data = "results_alleles.tsv",
	filtered_allelecall_data = "filtered_allele_results.tsv",
	result_stats = "results_statistics.tsv",
	hamming_dists = "hamming_distances.tsv",
	dendrogram = "dendrogram.phylo"
      )
    )
}

if (workflow == "core_genome") {
    rmarkdown::render(
      input  = 'core_genome_report.Rmd',
      params = list(
        parsnp_report = "parsnpAligner.log",
        phylo_data = "iqtree.iqtree",
        snpdist_report = "snp_dists.tab",
        phylo_tree = "iqtree.treefile"
      )
    ) 
}

if (workflow == "core_gene") {
    rmarkdown::render(
      input  = 'core_gene_report.Rmd',
      params = list(
        pangenome_data = "summary_statistics.txt",
        phylo_data = "iqtree.iqtree",
        snpdist_report = "snp_dists.tab",
        phylo_tree = "iqtree.treefile"
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
        phylo_tree = "iqtree.treefile"
      )
    )
}
