#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

path    <- args[1]
pattern <- args[2]

if (grepl("/$", path) == FALSE) {
  path <- paste0(path, "/")
}

library(dplyr)
library(stringr)
library(ggplot2)
library(patchwork)

# path = "/mnt/2T/temp/ALPPACA_FastANI_Rclean_script" # remove
# pattern = "FASTANI_results.txt" # remove
file <- list.files(path = path, pattern = pattern)

fastani_result <- read.table(file)
names(fastani_result) <- c("ID1", "ID2", "ANI", 'Count Bidirectional Fragments Mappings', 'Total Query Fragments')



# helper Sorting order to remove duplicates
keysort <- function(x,y) {
  sorted <- sort(c(x,y))
  paste0(sorted[1], "_", sorted[2])
  }

# Removes paths and extension from ID
regex_pattern <- regex("^(.*/)|([:punct:]?.((fasta)|(fna)|(fa)))")

fastani <-
  fastani_result %>%
  dplyr::mutate(ID1 = str_remove_all(ID1, regex_pattern),
                ID2 = str_remove_all(ID2,  regex_pattern),
                ANI = as.numeric(ANI),
                sortkey =  purrr::map2(ID1, ID2, ~keysort(.x, .y))) %>%
  # removal self comparison
  filter(ID1 != ID2) %>%
  arrange(sortkey) %>%
  group_by(sortkey) %>%
  # keep first one of comparison (ID1,ID2) == (ID2,ID1)
  slice(1) %>%
  ungroup() %>%
  select(-sortkey)


boxplot_plot <-
  ggplot(fastani, aes(x = ANI, y = "1")) +
  geom_boxplot(fill = "green",
               outlier.colour = "red",
               outlier.size = 2) +
  stat_summary(geom = "text", fun = quantile,
               aes(label = ..x.., y = 1.5),
               size = 2, angle = 45) +
  labs(title = "ANI distribution (boxplot)",
       subtitle = "Text indicates quantiles") +
  theme_bw()

density_plot <-
  ggplot(fastani, aes(x = ANI, y = ANI)) +
  geom_point(alpha = 0.4, size = .5) +
  geom_density_2d_filled(alpha = 0.8) +
  geom_density_2d(colour = "black", size = .2) +
  labs(title = "ANI distribution (2D density plot)") +
  theme_bw()


distribution_plot <- boxplot_plot / density_plot

ggsave("ANI_distribution.png",
       distribution_plot,
       width = 15, height = 15,
       units = "cm",
       dpi = 300)

