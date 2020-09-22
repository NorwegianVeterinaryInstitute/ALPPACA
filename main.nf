// PhyloFlow Pipeline

// Activate dsl2
nextflow.enable.dsl=2

// Processes
process PARSNP {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/ParSNP"
	publishDir "${params.out_dir}/logs", pattern: "parsnp.log", mode: "copy"
	publishDir "${params.out_dir}/results", pattern: "results/parsnpAligner.log", mode: "copy", saveAs: {"PARSNP_results.txt"}
	publishDir "${params.out_dir}/results", pattern: "results/parsnp.ggr", mode: "copy", saveAs: {"PARSNP_gingr_archive.ggr"}

	input:
	file("*")

	output:
	path "results/*.xmfa", emit: xmfa_ch
	file("results/parsnpAligner.log")
	file("results/parsnp.ggr")
	file("parsnp.log")

	script:
	"""
	parsnp -d *.fasta -p 4 -o results -r $params.parsnp_ref -v -c &> parsnp.log
	"""
}

process SNIPPY {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Snippy"
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

process GUBBINS {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Gubbins"
	publishDir "${params.out_dir}/logs", pattern: "gubbins.log", mode: "copy"
	publishDir "${params.out_dir}/results", pattern: "*filtered_polymorphic_sites.fasta", mode: "copy", saveAs: {"GUBBINS_filtered_alignment.aln"}
	publishDir "${params.out_dir}/results", pattern: "*per_branch_statistics.csv", mode: "copy", saveAs: {"GUBBINS_statistics.txt"}

	input:
	file(alignment)

	output:
	path "*filtered_polymorphic_sites.fasta", emit: filtered_alignment_ch
	path "*", emit: gubbins_ch
	
	script:
	"""
	run_gubbins.py $alignment -t $params.treebuilder -r $params.gubbinsmodel --threads $task.cpus -v --prefix gubbins_out &> gubbins.log
	"""
}

process MASKRC {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/maskrc-svg"
	publishDir "${params.out_dir}/logs", pattern: "*.log", mode: "copy"
	publishDir "${params.out_dir}/results", pattern: "masked.aln", mode: "copy", saveAs: {"MASKRC_masked_alignment.aln"}
	publishDir "${params.out_dir}/results", pattern: "recombinant_regions", mode: "copy", saveAs: {"MASKRC_recombinant_regions.txt"}
	publishDir "${params.out_dir}/results", pattern: "recombinant_plot", mode: "copy", saveAs: {"MASKRC_recombinant_plot.svg"}

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

process IQTREE {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/IQTree"
	publishDir "${params.out_dir}/logs", pattern: "*.log", mode: "copy"
	publishDir "${params.out_dir}/results", pattern: "*.contree", mode: "copy", saveAs: {"IQTREE_tree.phylo"}
	publishDir "${params.out_dir}/results", pattern: "*.iqtree", mode: "copy", saveAs: {"IQTREE_results.txt"}

	label 'longtime'

	input:
	file(alignment_filtered)

	output:
	file("*")

	script:
	"""
	iqtree -s $alignment_filtered -m $params.iqtree_model -bb $params.bootstrap -nt AUTO -pre iqtree -v $params.outgroup &> iqtree.log
	"""
}

process SNPDIST {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/snp-dists"
	publishDir "${params.out_dir}/results", pattern: "snp_dists.tab", mode: "copy", saveAs: {"SNPDIST_results.txt"}
	
	input:
	file(snp_alignment)

	output:
	file("*")

	script:
	"""
	snp-dists $snp_alignment > snp_dists.tab
	"""
}

process PROKKA {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Panaroo"

	label 'heavy'

	input:
	file(assembly)

	output:
	path "*.gff", emit: prokka_ch
	file("*")

	script:
	"""
	prokka --addgenes --compliant --prefix $assembly.baseName --cpus $task.cpus --outdir . --force $assembly
	"""
}

process PANAROO_QC {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Panaroo"
	publishDir "${params.out_dir}/results", pattern: "*.png", mode: "copy"
	publishDir "${params.out_dir}/results", pattern: "mash_dist.txt", mode: "copy", saveAs: {"PANAROO_mashdist.txt"}
	publishDir "${params.out_dir}/logs", pattern: "panaroo_qc.log", mode: "copy"

	label 'bigmem'

	input:
	file(gffs)

	output:
	file("*")

	script:
	"""
	panaroo-qc -i $gffs -o . -t $task.cpus --graph_type all --ref_db $params.refdb &> panaroo_qc.log
	"""
}

process PANAROO_PANGENOME {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Panaroo"
	publishDir "${params.out_dir}/results", pattern: "core_gene_alignment.aln", mode: "copy", saveAs: {"PANAROO_core_gene_alignment.aln"}
	publishDir "${params.out_dir}/results", pattern: "summary_statistics.txt", mode: "copy", saveAs: {"PANAROO_pangenome_results.txt"}
	publishDir "${params.out_dir}/logs", pattern: "panaroo_pangenome.log", mode: "copy"

	label 'heavy'

        input:
        file(gffs)

        output:
        path "core_gene_alignment.aln", emit: core_alignment_ch
	file("*")

        script:
        """
	panaroo -i $gffs -o . -t $task.cpus -a core --clean-mode $params.clean_mode --aligner mafft &> panaroo_pangenome.log
	"""
}

// workflows

workflow PARSNP_PHYLO {
	assemblies_ch=channel.fromPath(params.assemblies, checkIfExists: true)
			     .collect()

	PARSNP(assemblies_ch)
	CONVERT(PARSNP.out.xmfa_ch)
	if (params.deduplicate) {
		DEDUPLICATE(CONVERT.out.fasta_alignment_ch)
		GUBBINS(DEDUPLICATE.out.seqkit_ch)
		MASKRC(GUBBINS.out.gubbins_ch,
		       DEDUPLICATE.out.seqkit_ch)
	}
	if (!params.deduplicate) {
		GUBBINS(CONVERT.out.fasta_alignment_ch)
		MASKRC(GUBBINS.out.gubbins_ch,
		       CONVERT.out.fasta_alignment_ch)
	}
	SNPDIST(MASKRC.out.masked_ch)
	IQTREE(MASKRC.out.masked_ch)
}

workflow SNIPPY_PHYLO {
	reads_ch=channel.fromPath(params.reads, checkIfExists: true)
                        .collect()

        SNIPPY(reads_ch)
	if (params.deduplicate) {
                DEDUPLICATE(SNIPPY.out.snippy_alignment_ch)
                GUBBINS(DEDUPLICATE.out.seqkit_ch)
		MASKRC(GUBBINS.out.gubbins_ch,
		       DEDUPLICATE.out.seqkit_ch)
        }
        if (!params.deduplicate) {
                GUBBINS(SNIPPY.out.snippy_alignment_ch)
		MASKRC(GUBBINS.out.gubbins_ch,
		       SNIPPY.out.snippy_alignment_ch)
        }
        SNPDIST(MASKRC.out.masked_ch)
        IQTREE(MASKRC.out.masked_ch)
}

workflow CORE_PHYLO {
	assemblies_ch=channel.fromPath(params.assemblies, checkIfExists: true)

	PROKKA(assemblies_ch)
	PANAROO_QC(PROKKA.out.prokka_ch.collect())
	PANAROO_PANGENOME(PROKKA.out.prokka_ch.collect())
	if (params.deduplicate) {
                DEDUPLICATE(PANAROO_PANGENOME.out.core_alignment_ch)
                SNPDIST(DEDUPLICATE.out.seqkit_ch)
        	IQTREE(DEDUPLICATE.out.seqkit_ch)
        }
        if (!params.deduplicate) {
		SNPDIST(PANAROO_PANGENOME.out.core_alignment_ch)
        	IQTREE(PANAROO_PANGENOME.out.core_alignment_ch)
        }
}

workflow {
if (params.type == "reads") {
	SNIPPY_PHYLO()
	}

if (params.type == "assembly") {
	PARSNP_PHYLO()
	}

if (params.type == "core") {
	CORE_PHYLO()
	}
}
