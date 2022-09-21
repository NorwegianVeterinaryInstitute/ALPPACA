process MASKRC {
        publishDir "${params.out_dir}/logs", pattern: "*.log", mode: "copy"
        publishDir "${params.out_dir}/results", pattern: "masked.aln", mode: "copy", saveAs: {"MASKRC_masked_alignment.aln"}
        publishDir "${params.out_dir}/results", pattern: "recombinant_regions", mode: "copy", saveAs: {"MASKRC_recombinant_regions.txt"}
        publishDir "${params.out_dir}/results", pattern: "recombinant_plot", mode: "copy", saveAs: {"MASKRC_recombinant_plot.svg"}

	container 'quay.io/biocontainers/maskrc-svg:0.5--1'

        input:
        path(gubbins_folder)
        path(alignment)

        output:
        file("*")
        path "masked.aln", emit: masked_ch

        script:
        """
        mkdir gubbins
        mv $gubbins_folder gubbins/
        maskrc-svg.py --aln $alignment --gubbins gubbins/gubbins_out --symbol N --out masked.aln --region recombinant_regions --svg recombinant_plot --svgcolour "#1D00F8" &> maskrc.log
        """
}

