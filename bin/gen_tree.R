#!/usr/bin/env Rscript

# load library
library(ggtree)

# load function
gen_tree <- function(tree,
                     labelsize = 1, 
                     pointsize = 1, 
                     linesize = 1,
                     expand_x = 1,
                     plot_height = 20,
                     plot_width = 20) {
  p <- ggtree(tree,
              size = linesize) +
    geom_nodepoint(aes(subset = as.numeric(label) >= 95),
                   fill = "#39AEA9",
                   pch = 21,
                   size = pointsize - 0.4) +
    geom_tippoint(size = pointsize) +
    geom_tiplab(size = labelsize) +
    geom_treescale() +
    hexpand(expand_x)
  
  ggsave("tree.png",
         p,
         device = "png",
         units = "cm",
         dpi = 600,
         height = plot_height,
         width = plot_width)
}

tree <- read.tree("iqtree.contree")

options(bitmapType='cairo')

if (length(tree$tip.label) <= 50) {
  suppressWarnings(
    gen_tree(
      tree,
      labelsize = 4,
      pointsize = 2,
      linesize = 1,
      plot_height = 15,
      plot_width = 15
    )
  )
}

if (length(tree$tip.label) <= 100 & length(tree$tip.label) > 50) {
  suppressWarnings(
    gen_tree(
      tree,
      labelsize = 3,
      pointsize = 2,
      linesize = 1,
      plot_height = 20,
      plot_width = 20
    )
  )
}

if (length(tree$tip.label) <= 200 & length(tree$tip.label) > 100) {
  suppressWarnings(
    gen_tree(
      tree,
      labelsize = 2,
      pointsize = 1.5,
      linesize = 0.6,
      plot_height = 25,
      plot_width = 25
    )
  )
}

if (length(tree$tip.label) > 200) {
  suppressWarnings(
    gen_tree(
      tree,
      labelsize = 1.5,
      pointsize = 1,
      linesize = 0.4,
      plot_height = 30,
      plot_width = 30
    )
  )
}
