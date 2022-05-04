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
Phylogenetic analysis is a crucial part of population genomics. However, the complexity of running the analysis and interpreting the results is still a hindrance for many non-bioinformaticians. Additionally, choosing which software to run for each analysis may be difficult, as several similar software has been developed in parallell. Here we present A tooL for Prokaryotic Phylogeny And Clustering Analysis (ALPPACA), a Nextflow [@DiTommaso:2017] pipeline for phylogenetic analysis of prokaryotic genomes. The pipeline has been developed to make it easier to run phylogenetic analysis and provides reports that makes it easier to interpret the results. 

# Statement of need
The pipeline consists of three separate tracks depending on the needs of the user. The core gene track takes assemblies as input, and starts by running annotations with Prokka [@Seeman:2014]. Then, a pangenome analysis is run with Panaroo [@Tonkin-Hill:2020]. After the pangenome analysis, different optional paths can be taken, such as deduplication with Seqkit [@Shen:2016] and removal of constant sites with snp-sites [@Page:2016]. SNP distances are calculated from either the deduplicated alignment or full alignment using snp-dists (https://github.com/tseemann/snp-dists). Lastly, the phylogenetic tree is calculated by using IQTree [@Nguyen:2015]. The core gene track is useful for bigger datasets where a high level of diversity is expected. The second track, core genome, also takes assemblies as input and runs ParSNP [@Treangen:2014] to generate a core genome alignment. Similar to the core gene track, a deduplication step is optional after generating the alignment. Then, Gubbins [@Croucher:2015] is run to identify recombinant areas, followed by masking these areas in the alignment with maskrc-svg (https://github.com/kwongj/maskrc-svg). SNP-distances are calculated from the masked alignment with snp-dists. An optional step of removing constant sites is included, before calculating the phylogenetic tree with IQTree. The core genome track is useful for smaller datasets where a high level of similarity is expected, such as isolates from the same sequence type or subspecies. Lastly, the mapping pipeline takes reads as input, and maps these to a reference provided by the user with Snippy (https://github.com/tseemann/snippy). Then, it follows the same workflow as the core genome track described above. Similarly to the core genome track, the mapping track is useful for highly similar isolates where comparing to a specific reference is of interest.

The pipeline utilize singularity containers for running the different tools, which can be easily downloaded by using the setup shell script included in the repository. These images ensures that the user runs the correct versions of the tools, and makes the pipeline portable and reproducible. All images, except the R image, are verified and hosted by galaxyproject.org. The R image is curated by the authors and hosted at Sylabs. 

As ALPPACA is a Nextflow pipeline, each process (tool) has been tested and given the time, memory, and CPU it requires to run various dataset sizes. However, the pipeline is not meant for very large datasets, such as thousands of isolates. The user may however change these settings in the nextflow.config file to reflect their systems and needs. 

To test the pipeline after installation, the user may download a test dataset described in the documentation. The user may compare to existing results from the same version of the pipeline. This ensures that the pipeline is running correctly.



# Acknowledgements
The project QREC-MaP, funded by the Research Funding for Agriculture and the Food Industry (NFR project 255383), and the project KLEB-GAP, funded by the Trond Mohn Foundation (project number TMS2019TMT03) are acknowledged for providing the research platform for this work. The computations were performed on resources provided by UNINETT Sigma2 - the National Infrastructure for High Performance Computing and Data Storage in Norway.

# References


