include { PREPARE_TABLE             } from "../modules/PREPARE_TABLE.nf"
include { CHEWBBACA_ALLELECALL      } from "../modules/CHEWBBACA.nf"
include { CHEWBBACA_DOWNLOAD_SCHEMA } from "../modules/CHEWBBACA.nf"

workflow CGMLST {
	input_list_ch = Channel
                .fromPath(params.input, checkIfExists: true)
                .splitCsv(header:true, sep:",")
                .map { file(it.path, checkIfExists: true) }
                .collect()

	species_ch = Channel.value(params.species_value)
	id_ch	   = Channel.value(params.id_value)

	PREPARE_TABLE(input_list_ch)

	CHEWBBACA_DOWNLOAD_SCHEMA(species_ch, id_ch)
	CHEWBBACA_ALLELECALL(PREPARE_TABLE.out.reflist_ch,
		             CHEWBBACA_DOWNLOAD_SCHEMA.out.schema_ch)
}
