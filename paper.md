---
title: 'ALPPACA - A tooL for Prokaryotic Phylogeny And Clustering Analysis'
tags:
  - Nextflow
  - Phylogeny
  - Prokaryote
  - Clustering
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
A tooL for Prokaryotic Phylogeny And Clustering Analysis (ALPPACA) is a pipeline that allows both *de-novo* and reference-based phylogenetic analysis of prokaryotic genomes. The pipeline provides a suite of analyses tailored for different scenarios, designed to allow analysis of datasets represented by three different genetic diversity levels, all in one package. These levels of similarity influence what assumptions are used to consider sequences as orthologous when reconstructing the multiple alignment required for phylogenetic inference. By selecting an appropriate track for the data at hand, the user can be confident that these assumptions are taken care of within the framework of ALPPACA.

# Statement of need
Phylogenetic analysis is frequently used to unravel outbreaks and track the origins of pathogens worldwide. Phylogenetic analysis has also become commonplace in several research projects and clinical investigations, where time is often of the essence. This kind of analysis often entails running several tools consecutively, and many assumptions are made for the data used in each tool. To add to this complexity, several tools have been developed for each step in such an analysis, and sifting through these tools as a user may be time-consuming. Additionally, choosing a combination of compatible software for various analysis scenarios may require in-depth knowledge and experience in the field of microbial evolution, which often prevents non-specialists from utilizing such analyses. Here we present a solution that will help alleviate these problems in hopes of making it easier and faster to run reproducible phylogenetic analyses.

# State of the field
The ability to run different datasets through different tracks within the same framework makes ALPPACA unique compared to other phylogeny pipelines such as Bactmap (https://nf-co.re/bactmap) and SNVPhyl (https://github.com/DHQP/SNVPhyl_Nextflow), where only mapping-based phylogeny is possible. Several research projects have provided the developmental platform of ALPPACA, and peer-reviewed papers have been published using this framework for phylogenetic analysis [@Kaspersen:2020;@Franklin-Alming:2021;@Smistad:2022;@Kravik:2022].

# Pipeline and track descriptions
## Pipeline
The ALPPACA pipeline is written in Nextflow [@DiTommaso:2017], and the code and documentation are publicly available on Github  (https://github.com/NorwegianVeterinaryInstitute/ALPPACA). The user have the option of running the pipeline using different container handlers, such as docker, singularity, or conda. Each track generates a tidy html report summarizing the main results from each analysis.

## Tracks
The pipeline consists of three separate tracks depending on the objectives and data available to the user (\autoref{fig:figure1}). Each track differ in the way they detect homologous regions to construct the multiple alignment needed for phylogenetic inference.

First, the core gene track is designed to be used for datasets that are expected to have a relatively high level of genetic diversity. This track is useful if you have a dataset with different but closely related species, or different STs of the same species. The track provides the means to generate a relatively high resolution phylogeny on diverse datasets. Here, the genomes are annotated with Prokka [@Seemann:2014], the pangenome is inferred using Panaroo [@Tonkin-Hill:2020], and a core gene alignment is produced and used for phylogenetic reconstruction with IQTree [@Nguyen:2015].

The mapping track is designed for datasets that are expected to have a medium to low diversity level. This track maps reads to a reference using Snippy (https://github.com/tseemann/snippy). Mapping reads circumvent the need to generate assemblies, which is a time-consuming process. Time is usually of the essence in an outbreak situation, and this track allows for rapid analysis of outbreak data. Additionally, this track ensures that only genetic material from vertical descent is included in the analysis, as recombinant areas are detected by Gubbins [@Croucher:2015] and masked with Maskrc-svg (https://github.com/kwongj/maskrc-svg) before the phylogeny is inferred with IQTree. 

Lastly, the core genome track is designed to be used for datasets that are expected to have a low level of genetic diversity, e.g. within the same ST. This track is useful after identifying clusters of interest using the core gene track above, to increase the resolution of the phylogenetic analysis on a subset of the dataset. This track outputs the percent length of each genome included in the alignment, reported as average genome coverage by ParSNP [@Treangen:2014]. This is an important parameter to consider when interpreting the results, as it tells the user how much of each genome the phylogenetic inference is based on. Similar to the mapping track, only data from vertical descent is included in the analysis.

All three tracks also generate SNP distance statistics with snp-dists (https://github.com/tseemann/snp-dists). The SNP distances are very useful when defining clusters, or if defining outbreak clades based on a SNP distance cutoff. The user also has options to deduplicate the alignment with Seqkit [@Shen:2016], and filter out constant sites with snp-sites [@Page:2016], which will reduce runtime of the pipeline.

![Overview of the three tracks in ALPPACA.\label{fig:figure1}](pipeline.png)

# Conclusion
The ALPPACA pipeline provides a suite of phylogenetic analyses for different scenarios, all in one package. This enables a variety of uses without having to download several tools and programs, and the Nextflow framework allows for user-friendly and reproducible use of the pipeline. Additional tracks may be added to ALPPACA in the future, such as clusering based on core/whole genome multi locus sequence typing, or additions to existing tracks, such as recombination detection in the core gene analysis. Clustering analysis using FastANI (https://github.com/ParBLiSS/FastANI) will be added as a separate track, to assist users in selecting the correct track by evaluating genetic diversity in their dataset.

# Acknowledgements
The projects QREC-MaP (Research Funding for Agriculture and the Food Industry, Norwegian Research Council, project number 255383), KLEB-GAP (Trond Mohn Foundation, project number TMS2019TMT03), Yersiniosis at Sea (Norwegian Seafood Research Fund grant, project number 901505), and Increasing sustainability of Norwegian food production by tackling streptococcal infections in modern livestock systems (FFL/JA, Norwegian Agricultural Agreement Research Fund, project number 280364) are acknowledged for providing the research platform for this work. The computations were performed on resources provided by UNINETT Sigma2 - the National Infrastructure for High Performance Computing and Data Storage in Norway.

# References
