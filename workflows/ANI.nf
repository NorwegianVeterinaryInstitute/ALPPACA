include { PREPARE_TABLE   } from "../modules/PREPARE_TABLE.nf"
include { FASTANI         } from "../modules/FASTANI.nf"
include { FASTANI_VERSION } from "../modules/FASTANI.nf"
include { REPORT_ANI      } from "../modules/REPORT.nf"

workflow ANI {
	 if (!params.input) {
                exit 1, "Missing input file"
        }

	assemblies_ch = Channel
		.fromPath(params.input, checkIfExists: true)
		.splitCsv(header:true, sep:",")
		.map { it -> tuple(it.sample, file(it.path, checkIfExists: true)) }

	input_list_ch = Channel
		.fromPath(params.input, checkIfExists: true)
		.splitCsv(header:true, sep:",")
		.map { file(it.path, checkIfExists: true) }
		.collect()

	PREPARE_TABLE(input_list_ch)
	FASTANI_VERSION()
	FASTANI(assemblies_ch, PREPARE_TABLE.out.reflist_ch)
	
	FASTANI.out.fastani_ch
		.collectFile(name:'FASTANI_results.txt',
			     storeDir:"${params.out_dir}/results")

	REPORT_ANI(FASTANI.out.fastani_ch.collect())
}
