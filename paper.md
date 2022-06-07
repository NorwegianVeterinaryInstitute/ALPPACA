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
Unravelling the evolutionary relationship between organisms is a crucial part of many comparative genomics projects. However, the complexity of preparing, running, and interpreting such analyses is a hindrance for many researchers %% not specialized %% ~~interested~~ in evolutionary biology. Additionally, choosing which software to run for each analysis %%lacking the serie idea: make them work together%% may be difficult, as several similar software has been developed in parallel. Here we present A tooL for Prokaryotic Phylogeny And Clustering Analysis (ALPPACA), a Nextflow [@DiTommaso:2017] pipeline for phylogenetic analysis of prokaryotic genomes. The pipeline has been developed to make it easier to run phylogenetic analysis and provides reports to simplify result interpretation. ~~that makes it easier to interpret the results.~~ 

# Statement of need
The pipeline consists of three separate tracks depending on the objectives and data available to~~needs of~~ the user. The core gene track takes assemblies as input, and starts by running annotations with Prokka [@Seemann:2014]. Then, a pangenome analysis is run with Panaroo [@Tonkin-Hill:2020]. After the pangenome analysis, different optional paths can be taken, such as deduplication with Seqkit [@Shen:2016] and removal of constant sites with snp-sites [@Page:2016] %%which facilitates analysis of large dataset %%. SNP distances are calculated from either the deduplicated alignment or full alignment using snp-dists (https://github.com/tseemann/snp-dists). Lastly, the phylogenetic tree is inferred with IQTree [@Nguyen:2015] %% which by default will automatically run model testing for choosing the best model fit given the users'data%% . The core gene track is useful for bigger datasets where a high level of diversity is expected. The second track, core genome, also takes assemblies as input and runs ParSNP [@Treangen:2014] %%which is recommended for datasets where taxa are highly similar %% to generate a core genome alignment. Similar to the core gene track, a deduplication step is optional after generating the alignment. Then, Gubbins [@Croucher:2015] is run to identify recombinant areas %%should we state purpose?%% which are subsequently masked with maskrc-svg (https://github.com/kwongj/maskrc-svg). SNP-distances are calculated from the masked alignment with snp-dists. An optional step of removing constant sites is included, before calculating the phylogenetic tree with IQTree %% which should then be used with the Ascertainment Bias correction ooptional [ASC](http://www.iqtree.org/doc/Substitution-Models#ascertainment-bias-correction) (? is it automatic to provide the parameters to IQTREE?)%%. The core genome track is useful for ~~smaller~~ datasets where a high level of similarity is expected, such as isolates from the same sequence type or subspecies %%ok or above as I started to rectify%%. Lastly, the mapping pipeline takes reads as input, and maps these to a reference genome provided by the user and reconstruct the multiple-genome alignment with Snippy (https://github.com/tseemann/snippy). Then, it follows the same workflow as the core genome track described above. Similarly to the core genome track, the mapping track is useful for highly similar isolates where comparing to a specific reference%%, which can be one of the isolate of the dataset%%  is of interest.

The pipeline utilize singularity containers for running the different tools, which can be easily downloaded by using the setup shell script included in the repository. These images ensures that the user runs the correct versions of the tools, and makes the pipeline portable and reproducible. All images, except the R image, are verified and hosted by <galaxyproject.org>. The R image is curated by the authors and hosted at Sylabs %%link?%%. 

As ALPPACA is a Nextflow pipeline, each process (tool) has been tested and given the time, memory, and CPU it requires to run various dataset sizes. %%THIS ONE is unclear - we discuss how to formulate%% However, the pipeline is not meant for very large datasets, such as thousands of isolates %%could the adaptation that you had done be done for the huge dataset done with a special config??%%. The user may however change these settings in the nextflow.config file to reflect their systems requirements. 

To test the pipeline after installation, the user may download a test dataset as described in the documentation. %% did you put a seed ?%% %%This allows to ensure that the installation is successful and that the results are reproducible. ? modify %%The user may compare to existing results from the same version of the pipeline. This ensures that the pipeline is running correctly.

![Overview of the three tracks in ALPPACA](pipeline.png)

# Acknowledgements
The project QREC-MaP, funded by the Research Funding for Agriculture and the Food Industry (NFR project 255383), and the project KLEB-GAP, funded by the Trond Mohn Foundation (project number TMS2019TMT03) %% should we add when part of the workflow I was using developed ? which is yersinia ?%% are acknowledged for providing the research platform for this work. The computations were performed on resources provided by UNINETT Sigma2 - the National Infrastructure for High Performance Computing and Data Storage in Norway.

# References


