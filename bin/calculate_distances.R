#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

clustering_method = args[1]

# Load libraries
library(readr)
library(dplyr)
library(tidyr)
library(tibble)
library(cluster)
library(purrr)
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
transposed_data <- as.data.frame(as.matrix(t(data)))

hamming <- combn(colnames(transposed_data), 2, simplify = FALSE) %>%
  map_df(function(col) {
    data.frame(
      isolate1 = col[1], 
      isolate2 = col[2], 
      hamming = sum(
        transposed_data[,col[1]] != transposed_data[,col[2]],
        na.rm = TRUE
      ),
      compared_alleles = sum(
        !is.na(transposed_data[,col[1]]) & !is.na(transposed_data[,col[2]])
      ),
      typed_alleles = sum(
        !is.na(transposed_data[,col[1]]) | !is.na(transposed_data[,col[2]])
      ),
      missing_alleles = sum(
        is.na(transposed_data[,col[1]]) | is.na(transposed_data[,col[2]])
      )
    )
  }
  )

write_delim(
  hamming,
  "hamming_distances.tsv",
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

