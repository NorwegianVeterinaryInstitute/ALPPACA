---
title: 'ALPPACA - A tooL for Prokaryotic Phylogeny And Clustering Analysis'
tags:
  - Nextflow
  - Phylogeny
  - Prokaryote
  - R
authors:
  - name: Håkon Kaspersen
    orcid: 0000-0002-9559-1303
    affiliation: 1
  - name: Eve Zeyl Fiskebeck
    orcid: 0000-0002-6858-1978
    affiliation: 1
affiliations:
 - name: Norwegian Veterinary Institute
   index: 1
date: 24.02.2022
bibliography: paper.bib
---

# Summary
ALPPACA (A tooL for Prokaryotic Phylogeny And Clustering Analysis) is a Nextflow pipeline created to make it easier to run phylogenetic analysis on prokaryotic datasets. The pipeline consists of three tracks; core gene, core genome, and reference-based phylogeny. These tracks are used in different situations, depending on the needs of the user. For example, the core gene track is useful when comparing a set of divergent genomes with no apparent epidemiological link. On the other hand, the core genome track can be used on a set of closely related isolates to get a better resolution. The last track, mapping, is useful if you work with very closely related isolates and have a specific reference in mind. Since this track only use reads, it allows the user to skip the assembly step, thus reducing analysis time. The pipeline outputs several results from the individual programs, and also a markdown html report that sums up the most important results from each track.

# Statement of need


# Acknowledgements
QREC-MaP & KLEB-GAP

# Citations


