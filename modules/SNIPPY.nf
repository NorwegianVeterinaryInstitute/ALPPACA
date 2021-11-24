process SNIPPY {
        container "${container_dir}/snippy:4.6.0--hdfd78af_1"

        publishDir "${params.out_dir}/results", pattern: "core.full.aln", mode: "copy", saveAs: {"SNIPPY_alignment.aln"}
        publishDir "${params.out_dir}/results", pattern: "core.txt", mode: "copy", saveAs: {"SNIPPY_results.txt"}
        publishDir "${params.out_dir}/logs", pattern: "snippy.log", mode: "copy"

        label 'medium'

        input:
        file("*")

        output:
        path "core.full.aln", emit: snippy_alignment_ch
        file("*")

        script:
        """
        $baseDir/bin/snippyfy.bash "$params.R1" "$params.R2" "$params.suffix"
        snippy-multi snippy_samples.list --ref $params.snippyref --cpus $task.cpus > snippy.sh
        sh snippy.sh &> snippy.log
        """
}

