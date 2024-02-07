
# Changelog

## Version 2.3.1
- Updated the version of ParSNP to 2.0.3, as of issue #112
- Bumped software versions in all reports
- Added gffs as optional output with the command `--output_gffs`, as of issue #113


## Version 2.3.0
- Gubbins have been updated to version 3.3.2, and the `--seed` parameter now sets the seed for both IQ-Tree and Gubbins, as of isse #109
- Added Bakta as a replacement to Prokka in the core gene track, as of issue #54
- Updated the version of ParSNP from 1.6.1 to 1.7.4
- Added a parameter for running IQ-Tree in fast mode, as of issue #86. This addition has made the filter_snps parameter redundant, and this option has been deprecated
- Added columns for single-isolate metrics on allele distances, missing alleles, and typed alleles in the cgMLST track, as of issue #106
- Downgraded the mlst tool to get access to correct MLST scheme for listeria, as of issue #105
- Added parameters for identity threshold and sequence length cutoff for Panaroo as of issue #108
- Added `gene_presence_absence.tsv` output from Panaroo, as of issue #107
