// ALPPACA Pipeline


log.info "============================================================="
log.info ".          -------------------------------                  ."
log.info ".          |                             |                  ."
log.info ".   ----------------               -------------            ."
log.info ".   |              |               |           |            ."
log.info ".-------     -------------         |     ------------       ."
log.info ".|     |     |           |         |     |          |       ."
log.info ".A  tooL for Prokaryotic Phylogeny And   Clustering Analysis."
log.info "============================================================="
log.info " Run track: $params.track                                    "
log.info " Work directory: $workDir                                    "
log.info " ALPPACA Version: 1.0.0                                      "
log.info "=============================================================".stripIndent()

// Activate dsl2
nextflow.enable.dsl=2

// Define workflows
include { MAPPING } from "${params.workflow_dir}/MAPPING.nf"
include { CORE_GENE } from "${params.workflow_dir}/CORE_GENE.nf"
include { CORE_GENOME } from "${params.workflow_dir}/CORE_GENOME.nf"

workflow {
	if (params.track == "mapping") {
		MAPPING()
	}
	if (params.track == "core_genome") {
		CORE_GENOME()
	}
	if (params.track == "core_gene") {
		CORE_GENE()
	}
}

workflow.onComplete {
	log.info "".center(60, "=")
	log.info "ALPPACA Complete!".center(60)
	log.info "Output directory: $params.out_dir".center(60)
	log.info "Duration: $workflow.duration".center(60)
	log.info "Command line: $workflow.commandLine".center(60)
	log.info "Nextflow version: $workflow.nextflow.version".center(60)
	log.info "".center(60, "=")
}

workflow.onError {
	println "Pipeline execution stopped with the following message: ${workflow.errorMessage}".center(60, "=")
}
