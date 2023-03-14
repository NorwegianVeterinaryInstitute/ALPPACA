#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

max_missing <- args[1]

# Load libraries
library(readr)
library(dplyr)
library(tidyr)
library(stringr)

# Import data
data <- read_delim(
  "results_alleles.tsv",
  delim = "\t",
  col_types = cols(.default = "c")
)

# Clean data
data_clean <- data %>%
  mutate_at(vars(-FILE),
            function(x) str_remove_all(x, "INF-")) %>%
  mutate_at(vars(-FILE),
            function(x) str_replace_all(
              x,
              "(PLOT5)|(PLOT3)|(LNF)|(ASM)|(ALM)|(NIPH)|(NIPHEM)",
              NA_character_)) %>%
  mutate_at(vars(-FILE),
            as.factor)

# Filter out samples with too many 
# missing alleles
data_filtered <- data_clean %>%
  mutate(NA_count = apply(., 1, function(x) sum(is.na(x)))) %>%
  filter(NA_count < max_missing) %>%
  select(-NA_count)


# Write output
write_delim(
  data_filtered,
  "filtered_allele_results.tsv",
  delim = "\t"
)
