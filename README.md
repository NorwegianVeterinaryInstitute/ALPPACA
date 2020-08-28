# PhyloFlow
Nextflow pipeline for phylogenetic analysis.

## Disclaimer
This pipeline is currently under development. Contact Håkon Kaspersen for more information.

## Tracks
The pipeline consist of three tracks:

### CORE
This track identifies the core genes in the input assemblies by running Prokka [1],
followed by Panaroo QC and Panaroo pan-genome [2]. Then, a maximum likelihood (ML)
tree is generated with IQTree [3], and SNP distances calculated with snp-dists [4].

### ASSEMBLY
In this track, the core genome is identified using ParSNP [5]. Then, recombinant areas 
are removed with Gubbins [6], before the ML tree is generated with IQTree, and 
SNP-distances calculated with snp-dists. 

### READS
In this track, the core genome is generated through Snippy [7], which use reads
as input. Here too, recombinant areas are removed with Gubbins, and the tree generated
by IQTree. SNP-distances are calculated with snp-dists.

## References
[1] 10.1093/bioinformatics/btu153

[2] 10.1186/s13059-020-02090-4

[3] 10.1093/molbev/msu300

[4] https://github.com/tseemann/snp-dists

[5] 10.1186/s13059-014-0524-x

[6] 10.1093/nar/gku1196

[7] https://github.com/tseemann/snippy






Håkon Kaspersen,
14.08.2020
