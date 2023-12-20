

# Version 2.3.0
- Added a parameter for running IQ-Tree in fast mode, as of issue #86. This addition has made the filter_snps parameter redundant, and this option has been deprecated
- Added columns for single-isolate metrics on allele distances, missing alleles, and typed alleles in the cgMLST track, as of issue #106
- Downgraded the mlst tool to get access to correct MLST scheme for listeria, as of issue #105
- Added parameters for identity threshold and sequence length cutoff for Panaroo as of issue #108
- Added gene_presence_absence.tsv output from Panaroo, as of issue #107
