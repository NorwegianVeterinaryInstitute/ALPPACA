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
Phylogenetic analysis has during recent years become more and more popular, also in microbial comparative genomics. However, the complexity of running the analysis is still a hindrance for many non-bioinformaticians. ALPPACA (A tooL for Prokaryotic Phylogeny And Clustering Analysis) is a Nextflow pipeline created to make it easier to run phylogenetic analysis on prokaryotic datasets. The pipeline consists of three tracks; core gene, core genome, and reference-based phylogeny. These tracks are used in different situations, depending on the needs of the user. For example, the core gene track is useful when comparing a set of divergent genomes with no apparent epidemiological link. On the other hand, the core genome track can be used on a set of closely related isolates to get a better resolution. The last track, mapping, is useful if you work with very closely related isolates and have a specific reference in mind. Since this track only use reads, it allows the user to skip the assembly step, thus reducing analysis time. The pipeline outputs several results from the individual programs, and also a markdown html report that sums up the most important results from each track.

# Statement of need


# Workflows
The pipeline consists of three separate tracks (Figure 1), depending on the needs of the user. The core gene track takes assemblies as input, and starts by running annotations with Prokka [@Seeman2014]. Then, a pangenome analysis is run with Panaroo [@Tonkin-Hill2020]. After the pangenome analysis, different optional paths can be taken, such as deduplication with Seqkit [@Shen2016] and removal of constant sites with snp-sites [@Page2016]. SNP distances are calculated from either the deduplicated alignment or full alignment using snp-dists (https://github.com/tseemann/snp-dists). Lastly, the phylogenetic tree is calculated by using IQTree (Nguyen2015).
![Figure 1](https://github.com/NorwegianVeterinaryInstitute/ALPPACA/blob/joss_paper/pipeline.png)
**Figure 1:** ALPPACA tracks overview, created with www.biorender.com.

# Acknowledgements
QREC-MaP & KLEB-GAP

# Citations


