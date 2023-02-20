// ALPPACA Pipeline


log.info "".center(74, "=")
log.info ".                -------------------------------                         ."
log.info ".                |                             |                         ."
log.info ".         ----------------               -------------                   ."
log.info ".         |              |               |           |                   ."
log.info ".      -------     -------------         |     ------------              ."
log.info ".      |     |     |           |         |     |          |              ."
log.info ".      A  tooL for Prokaryotic Phylogeny And   Clustering Analysis       ."
log.info "".center(74, "=")
log.info "Run track: $params.track".center(74)
log.info "ALPPACA Version: $workflow.manifest.version".center(74)
log.info "".center(74, "=")

// Activate dsl2
nextflow.enable.dsl=2

// Define workflows
include { MAPPING      } from "./workflows/MAPPING.nf"
include { CORE_GENE    } from "./workflows/CORE_GENE.nf"
include { CORE_GENOME  } from "./workflows/CORE_GENOME.nf"
include { ANI } from "./workflows/ANI.nf"

workflow {
	if (params.track == "ani") {
		ANI()
	}
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
	log.info "".center(74, "=")
	log.info "ALPPACA Complete!".center(74)
	log.info "Output directory: $params.out_dir".center(74)
	log.info "Duration: $workflow.duration".center(74)
	log.info "Nextflow version: $workflow.nextflow.version".center(74)
	log.info "".center(74, "=")
}

workflow.onError {
	println "Pipeline execution stopped with the following message: ${workflow.errorMessage}".center(74, "=")
}
