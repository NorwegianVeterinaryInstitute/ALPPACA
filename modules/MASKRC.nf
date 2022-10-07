process MASKRC {
	conda (params.enable_conda ? 'bioconda::maskrc-svg=0.5' : null)
	container 'quay.io/biocontainers/maskrc-svg:0.5--1'

        input:
        path(gubbins_folder)
        path(alignment)

        output:
        file("*")
        path "masked.aln", emit: masked_ch

        script:
        """
	maskrc-svg.py --version > maskrc-svg.version
        mkdir gubbins
        mv $gubbins_folder gubbins/
        maskrc-svg.py --aln $alignment --gubbins gubbins/gubbins_out --symbol N --out masked.aln --region recombinant_regions --svg recombinant_plot --svgcolour "#1D00F8" &> maskrc.log
        """
}

