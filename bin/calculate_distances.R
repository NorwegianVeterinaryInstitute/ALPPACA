#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

clustering_method = args[1]

# Load libraries
library(readr)
library(dplyr)
library(tidyr)
library(tibble)
library(cluster)
library(cultevo)
library(ape)

# Import data
data <- read_delim(
  "filtered_allele_results.tsv",
  delim = "\t",
  col_types = cols(.default = "c")
) %>%
  mutate_at(vars(-FILE),
            as.factor) %>%
  column_to_rownames("FILE")

# Calculate dissimilarity matrix
dissimilarity <- daisy(
      data,
      metric = "gower"
      )

dissimilarity_output <- as.data.frame(
  as.matrix(
    dissimilarity
    )
  ) %>%
  rownames_to_column("FILE")

write_delim(
  dissimilarity_output,
  "dissimilarity_matrix.tsv",
  delim = "\t"
)

# Calculate hamming distance
rows <- rownames(data)

hamming <- as.data.frame(
  as.matrix(
    hammingdists(data)
    )
  ) %>%
  rename_all(function(x) rows) %>%
  mutate(FILE = rows) %>%
  select(FILE, everything())

write_delim(
  hamming,
  "hamming_matrix.tsv",
  delim = "\t"
)

# Run clustering
if (clustering_method == "single") {
  tree <- as.phylo(hclust(dissimilarity, "single"))
} else if (clustering_method == "nj") {
  tree <- nj(dissimilarity)
}

write.tree(
  tree,
  "dendrogram.phylo"
)

