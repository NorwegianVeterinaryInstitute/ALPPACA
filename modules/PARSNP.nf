process PARSNP {
	container "${params.container_dir}/parsnp:1.5.6--h9a82719_1"
        publishDir "${params.out_dir}/logs", pattern: "parsnp.log", mode: "copy"
        publishDir "${params.out_dir}/results", pattern: "results/parsnpAligner.log", mode: "copy", saveAs: {"PARSNP_results.txt"}
        publishDir "${params.out_dir}/results", pattern: "results/parsnp.ggr", mode: "copy", saveAs: {"PARSNP_gingr_archive.ggr"}
	publishDir "${params.out_dir}/results", pattern: "parsnp_alignment.fasta", mode: "copy", saveAs: {"PARSNP_alignment.aln"}

        input:
        file("*")

        output:
	path "parsnp_alignment.fasta", emit: fasta_alignment_ch
        file("results/parsnpAligner.log")
        file("results/parsnp.ggr")
        file("parsnp.log")

        script:
        """
        parsnp -d *.fasta -p 4 -o results -r $params.parsnp_ref -v -c &> parsnp.log
	harvesttools -x results/*xmfa -M parsnp_alignment.fasta
        """
}
