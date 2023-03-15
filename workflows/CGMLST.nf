include { CHEWBBACA_ALLELECALL      } from "../modules/CHEWBBACA.nf"
include { CHEWBBACA_DOWNLOAD_SCHEMA } from "../modules/CHEWBBACA.nf"
include { CHEWBBACA_PREP_SCHEMA     } from "../modules/CHEWBBACA.nf"
include { CLEAN_AND_FILTER          } from "../modules/RSCRIPTS.nf"
include { CALCULATE_DISTANCES       } from "../modules/RSCRIPTS.nf"

// VALIDATE INPUTS
if(!params.input) {
	exit 1, "Missing input file"
}

if(params.download_external) {
	if(!params.species_value) {
		exit 1, "Missing species value"
	}
	if(!params.id_value) {
		exit 1, "Missing dataset ID value"
	}
}

if(!params.download_external) {
	if(!params.schema) {
		exit 1, "Missing schema path"
	}
	if(!params.prepped_schema) {
		if(!params.ptf) {
			exit 1, "Missing prodigal training file"
		}
	}
}

// WORKFLOW
workflow CGMLST {

	input_list_ch = Channel
                .fromPath(params.input, checkIfExists: true)
                .splitCsv(header:true, sep:",")
                .map { file(it.path, checkIfExists: true) }
                .collect()

        if (params.download_external) {

                species_ch = Channel.value(params.species_value)
                id_ch      = Channel.value(params.id_value)

                CHEWBBACA_DOWNLOAD_SCHEMA(species_ch, id_ch)
                CHEWBBACA_ALLELECALL(input_list_ch,
                                     CHEWBBACA_DOWNLOAD_SCHEMA.out.schema_ch)
        }


	if (!params.download_external) {
		
		schema_dir_ch = Channel
			.fromPath(params.schema, checkIfExists: true)

		if (!params.prepped_schema) {

			ptf_ch = Channel
                        	.fromPath(params.ptf, checkIfExists: true)

			CHEWBBACA_PREP_SCHEMA(schema_dir_ch, ptf_ch)
			CHEWBBACA_ALLELECALL(input_list_ch,
					     CHEWBBACA_PREP_SCHEMA.out.schema_ch)
		}
		if (params.prepped_schema) {
			CHEWBBACA_ALLELECALL(input_list_ch,
					     schema_dir_ch)
		}
	}

	max_missing_alleles_ch = Channel
		.value(params.max_missing)

	clustering_method_ch = Channel
		.value(params.clustering_method)

	CLEAN_AND_FILTER(CHEWBBACA_ALLELECALL.out.typing_ch,
			 max_missing_alleles_ch)

	CALCULATE_DISTANCES(CLEAN_AND_FILTER.out.filtered_alleles_ch,
			    clustering_method_ch)
}
