process DEDUPLICATE {
        conda "/cluster/projects/nn9305k/src/miniconda/envs/seqkit"
        publishDir "${params.out_dir}/logs", pattern: "*.log", mode: "copy"
        publishDir "${params.out_dir}/results", pattern: "seqkit_deduplicated.fasta", mode: "copy", saveAs: {"SEQKIT_deduplicated_alignment.fasta"}
        publishDir "${params.out_dir}/results", pattern: "seqkit_list_duplicated", mode: "copy", saveAs: {"SEQKIT_duplicated_list.txt"}
        publishDir "${params.out_dir}/results", pattern: "seqkit_duplicated_seq", mode: "copy", saveAs: {"SEQKIT_duplicated_sequences.fasta"}

        input:
        file(fasta)

        output:
        file("*")
        path "seqkit_deduplicated.fasta", emit: seqkit_ch

        script:
        """
        seqkit rmdup $fasta -s -D seqkit_list_duplicated -d seqkit_duplicated_seq --alphabet-guess-seq-length 0 --id-ncbi -t dna -w 0 -o seqkit_deduplicated.fasta &> seqkit.log
        """
}

