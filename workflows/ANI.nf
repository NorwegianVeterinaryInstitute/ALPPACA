include { PREPARE_TABLE } from "../modules/PREPARE_TABLE.nf"
include { FASTANI       } from "../modules/FASTANI.nf"

workflow ANI {
	assemblies_ch = Channel
		.fromPath(params.input, checkIfExists: true)
		.splitCsv(header:true, sep:",")
		.map { row -> tuple(row.sample, file(row.path, checkIfExists: true)) }

	input_list_ch = Channel
		.fromPath(params.input, checkIfExists: true)

	PREPARE_TABLE(input_list_ch)
	FASTANI(assemblies_ch, PREPARE_TABLE.out.reflist_ch)
}
