#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

path    <- args[1]
pattern <- args[2]

if (grepl("/$", path) == FALSE) {
  path <- paste0(path, "/")
}

# find files
files <- list.files(path = path,
                    pattern = pattern)

filenames <- sub(pattern, "", files)

# generate dataframe  
df <- data.frame(
  sample = filenames
)
  
df$path <- paste0(path, files)

# write to file
write.table(
  x         = df,
  file      = "samplesheet.csv",
  quote     = FALSE,
  row.names = FALSE,
  sep       = ","
)

