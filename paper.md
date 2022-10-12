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
 - name: Norwegian Veterinary Institute, Ås, Norway
   index: 1
date: 24.02.2022
bibliography: paper.bib
---

# Summary


Phylogenetic analysis is often a complex and time-consuming process. We developed A tooL for Prokaryotic Phylogeny And Clustering Analysis (ALPPACA), a pipeline designed for phylogenetic analysis of prokaryotes. The pipeline is implemented in Nextflow and utilize singularity containers, which makes the pipeline portable and reproducible. The pipeline consists of three different tracks designed to cover three different levels of expected dataset diversity, facilitating the choice of performing appropriate analysis for different datasets. The final results are presented in a tidy HTML report for each track. The code, documentation and examples of configuration files to run analyses with are publicly available on Github.

# Statement of need
Unraveling the evolutionary relationship between organisms is a crucial part of many comparative genomics projects. Phylogenetic analysis often entails running several tools consecutively, and several assumptions are made for the data used in each tool. To add to this complexity, several tools have been developed for each step in such an analysis, and sifting through these tools as a user may be time-consuming and difficult. Additionally, choosing a combination of compatible software for various analysis scenarios may require in-depth knowledge and experience in the field of microbial evolution. To the authors knowledge, currently the only available Nextflow [@DiTommaso:2017] pipeline for a start-to-end phylogenetic analysis is bactmap (https://nf-co.re/bactmap). However, bactmap only allows reference-based phylogenetic analysis by mapping reads to a reference. Here, we present A tooL for Prokaryotic Phylogeny And Clustering Analysis (ALPPACA), a Nextflow pipeline for phylogenetic analysis of prokaryotic genomes. ALPPACA provides a suite of analyses tailored for different scenarios, designed to allow analysis of datasets represented by three different genetic diversity levels, all in one package. These levels of similarity influence what assumptions are used to consider sequences as orthologous when reconstructing the multiple alignment required for phylogenetic inference.

# Pipeline and track descriptions
## Pipeline
The ALPPACA pipeline is hosted on github (https://github.com/NorwegianVeterinaryInstitute/ALPPACA). The user have the option of running the pipeline using different container handlers, such as docker, singularity, or conda. 

## Tracks
The pipeline consists of three separate tracks depending on the objectives and data available to the user (\autoref{fig:figure1}). First, the core gene track is designed to be used for datasets that are expected to have a relatively high level of genetic diversity. This track is useful if you have a dataset with different but closely related species, or different STs of the same species. The track provides the means to generate a relatively high resolution phylogeny on diverse datasets. Here, the genomes are annotated with Prokka [@Seeman:2014], the pangenome is inferred using Panaroo [@Tonkin-Hill:2020], and a phylogenetic reconstruction is generated with IQTree [@Nguyen:2015] from a core gene alignment.

The core genome track is designed to be used for datasets that are expected to have a medium or low level of genetic diversity, e.g. within the same ST. This track is useful after f.ex. identifying clusters of interest using the core gene track above, to increase the resolution of the phylogenetic reconstruction on a subset of the dataset. This track outputs the percent length of each genome included in the alignment, reported as average genome coverage by by ParSNP [@Treangen:2014]. This is an important parameter to consider when interpreting the results, as it tells the user how much of each genome the phylogenetic inference is based on. Additionally, this track ensures that only genetic material from vertical descent is included in the analysis, as recombinant areas are detected by Gubbins [@Croucher:2015] and masked with Maskrc-svg (https://github.com/kwongj/maskrc-svg).

The last track, mapping, is designed for datasets that are expected to have a very low diversity level. This track generates a phylogeny by mapping reads to a reference using Snippy (https://github.com/tseemann/snippy). Mapping reads circumvent the need to generate assemblies, which is a time-consuming process. Time is usually of the essence in an outbreak situation, and this track allows for rapid analysis of outbreak data. Similar to the core genome track, only data from vertical descent is included in the analysis.

All three tracks also generate SNP distance statistics with snp-dists (https://github.com/tseemann/snp-dists). The SNP distances are very useful when defining clusters, or if defining outbreak clades based on a SNP distance cutoff. The user also has options to deduplicate the alignment with Seqkit [@Shen:2016], and filter out constant sites with snp-sites [@Page:2016], which will reduce runtime of the pipeline.

![Overview of the three tracks in ALPPACA.\label{fig:figure1}](pipeline.png)

# Conclusion
The ALPPACA pipeline offers a user-friendly way of running phylogenetic analysis on different datasets. The pipeline is reproducible and flexible, and only requires a few options and parameters to run. The Nextflow framework allows for easy development and additions to the pipeline in the future.

# Acknowledgements
The projects QREC-MaP (Research Funding for Agriculture and the Food Industry, Norwegian Research Council, project number 255383), KLEB-GAP (Trond Mohn Foundation, project number TMS2019TMT03), and Yersiniosis at Sea (Norwegian Seafood Research Fund grant, project number 901505) are acknowledged for providing the research platform for this work. The computations were performed on resources provided by UNINETT Sigma2 - the National Infrastructure for High Performance Computing and Data Storage in Norway.

# References
