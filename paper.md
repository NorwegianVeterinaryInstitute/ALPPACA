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
Phylogenetic analysis is a crucial part of population genomics. However, the complexity of running the analysis is still a hindrance for many non-bioinformaticians. 

# Statement of need
ALPPACA (A tooL for Prokaryotic Phylogeny And Clustering Analysis) is a Nextflow [@DiTommaso:2017] pipeline created to make it easier to run phylogenetic analysis on prokaryotic datasets. The pipeline consists of three separate tracks \autoref{fig:figure1}, depending on the needs of the user. The core gene track takes assemblies as input, and starts by running annotations with Prokka [@Seeman:2014]. Then, a pangenome analysis is run with Panaroo [@Tonkin-Hill:2020]. After the pangenome analysis, different optional paths can be taken, such as deduplication with Seqkit [@Shen:2016] and removal of constant sites with snp-sites [@Page:2016]. SNP distances are calculated from either the deduplicated alignment or full alignment using snp-dists (https://github.com/tseemann/snp-dists). Lastly, the phylogenetic tree is calculated by using IQTree [@Nguyen:2015]. The core gene track is useful for bigger datasets where a high level of diversity is expected. The second track, core genome, also takes assemblies as input and runs ParSNP [@Treangen:2014] to generate a core genome alignment. Similar to the core gene track, a deduplication step is optional after generating the alignment. Then, Gubbins [@Croucher:2015] is run to identify recombinant areas, followed by masking these areas in the alignment with maskrc-svg (https://github.com/kwongj/maskrc-svg). SNP-distances are calculated from the masked alignment with snp-dists. An optional step of removing constant sites is included, before calculating the phylogenetic tree with IQTree. The core genome track is useful for smaller datasets where a high level of similarity is expected, such as isolates from the same sequence type or subspecies. Lastly, the mapping pipeline takes reads as input, and maps these to a reference provided by the user with Snippy (https://github.com/tseemann/snippy). Then, it follows the same workflow as the core genome track described above. Similarly to the core genome track, the mapping track is useful for highly similar isolates where comparing to a specific reference is of interest.

![Figure 1.\label{fig:figure1}](https://github.com/NorwegianVeterinaryInstitute/ALPPACA/blob/joss_paper/pipeline.png)
**Figure 1:** ALPPACA tracks overview, created with www.biorender.com.

# Acknowledgements
QREC-MaP & KLEB-GAP

# References


