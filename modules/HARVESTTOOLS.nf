process CONVERT {
        conda "/cluster/projects/nn9305k/src/miniconda/envs/Harvesttools"
        publishDir "${params.out_dir}/results", pattern: "parsnp_alignment.fasta", mode: "copy", saveAs: {"PARSNP_alignment.aln"}

        input:
        file(xmfa)

        output:
        path "parsnp_alignment.fasta", emit: fasta_alignment_ch

        script:
        """
        harvesttools -x $xmfa -M parsnp_alignment.fasta
        """
}

