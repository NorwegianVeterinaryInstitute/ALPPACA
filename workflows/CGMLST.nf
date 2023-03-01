include { CHEWBBACA  } from "../modules/CHEWBBACA.nf"

workflow CGMLST {
	assemblies_ch = Channel
		.fromPath(params.input, checkIfExists: true)
		.splitCsv(header:true, sep:",")
		.map { it -> tuple(it.sample, file(it.path, checkIfExists: true)) }

}
