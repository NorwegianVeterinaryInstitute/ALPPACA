// PhyloFlow Pipeline

// Activate dsl2
nextflow.enable.dsl=2

// Processes
process PARSNP {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/ParSNP"
	publishDir "${params.outdir}", pattern: "parsnp.log", mode: "copy"
	publishDir "${params.outdir}/results", pattern: "results/*.log", mode: "copy", saveAs: {"PARSNP_results.txt"}

	input:
	file("*")

	output:
	path "results/*.xmfa", emit: xmfa_ch
	file("results/*.log")
	file("parsnp.log")

	script:
	"""
	parsnp -d *.fasta -p 4 -o results -r $params.parsnp_ref -v -c &> parsnp.log
	"""
}

process SNIPPY {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Snippy"
	publishDir "${params.outdir}/results", pattern: "core.full.aln", mode: "copy", saveAs: {"SNIPPY_alignment.aln"}
	publishDir "${params.outdir}/results", pattern: "core.txt", mode: "copy", saveAs: {"SNIPPY_results.txt"}
	publishDir "${params.outdir}", pattern: "snippy.log", mode: "copy"

	label 'medium'

	input:
	file("*")

	output:
	path "core.full.aln", emit: snippy_alignment_ch
	file("*")

	script:
	"""
	$baseDir/bin/snippyfy.bash $params.R1 $params.R2 $params.name
	snippy-multi snippy_samples.list --ref $params.snippyref --cpus $task.cpus > snippy.sh
	sh snippy.sh &> snippy.log
	"""
}

process CONVERT {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Harvesttools"
	publishDir "${params.outdir}/results", pattern: "parsnp_alignment.fasta", mode: "copy", saveAs: {"PARSNP_alignment.aln"}

	input:
	file(xmfa)

	output:
	path "parsnp_alignment.fasta", emit: fasta_alignment_ch

	script:
	"""
	harvesttools -x $xmfa -M parsnp_alignment.fasta
	"""

}

process GUBBINS {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Gubbins"
	publishDir "${params.outdir}", pattern: "gubbins.log", mode: "copy"
	publishDir "${params.outdir}/results", pattern: "*filtered_polymorphic_sites.fasta", mode: "copy", saveAs: {"GUBBINS_filtered_alignment.aln"}
	publishDir "${params.outdir}/results", pattern: "*per_branch_statistics.csv", mode: "copy", saveAs: {"GUBBINS_statistics.txt"}

	input:
	file(alignment)

	output:
	path "*filtered_polymorphic_sites.fasta", emit: filtered_alignment_ch
	file("*")
	
	script:
	"""
	run_gubbins.py $alignment -t $params.treebuilder -r $params.gubbinsmodel --threads $task.cpus -v &> gubbins.log
	"""
}

process IQTREE {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/IQTree"
	publishDir "${params.outdir}", pattern: "*.log", mode: "copy"
	publishDir "${params.outdir}/results", pattern: "*.contree", mode: "copy", saveAs: {"IQTREE_tree.phylo"}
	publishDir "${params.outdir}/results", pattern: "*.iqtree", mode: "copy", saveAs: {"IQTREE_results.txt"}

	input:
	file(alignment_filtered)

	output:
	file("*")

	script:
	"""
	iqtree -s $alignment_filtered -m $params.iqtree_model -bb $params.bootstrap -nt AUTO -pre iqtree -v &> iqtree.log
	"""
}

process SNPDIST {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/snp-dists"
	publishDir "${params.outdir}/results", pattern: "snp_dists.tab", mode: "copy", saveAs: {"SNPDIST_results.txt"}
	
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

	input:
	file(assembly)

	output:
	path "*.gff", emit: prokka_ch
	file("*")

	script:
	"""
	prokka --addgenes --compliant --prefix $assembly.baseName --outdir . --force $assembly
	"""
}

process PANAROO_QC {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Panaroo"
	publishDir "${params.outdir}/results", pattern: "*.png", mode: "copy"
	publishDir "${params.outdir}/results", pattern: "mash_dist.txt", mode: "copy", saveAs: {"PANAROO_mashdist.txt"}
	publishDir "${params.outdir}", pattern: "panaroo_qc.log", mode: "copy"

	label 'heavy'

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
	publishDir "${params.outdir}/results", pattern: "core_gene_alignment.aln", mode: "copy", saveAs: {"PANAROO_core_gene_alignment.aln"}
	publishDir "${params.outdir}/results", pattern: "summary_statistics.txt", mode: "copy", saveAs: {"PANAROO_pangenome_results.txt"}
	publishDir "${params.outdir}", pattern: "panaroo_pangenome.log", mode: "copy"

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
	GUBBINS(CONVERT.out.fasta_alignment_ch)
	SNPDIST(GUBBINS.out.filtered_alignment_ch)
	IQTREE(GUBBINS.out.filtered_alignment_ch)
}

workflow SNIPPY_PHYLO {
	reads_ch=channel.fromPath(params.reads, checkIfExists: true)
                        .collect()

        SNIPPY(reads_ch)
        GUBBINS(SNIPPY.out.snippy_alignment_ch)
        SNPDIST(GUBBINS.out.filtered_alignment_ch)
        IQTREE(GUBBINS.out.filtered_alignment_ch)
}

workflow CORE_PHYLO {
	assemblies_ch=channel.fromPath(params.assemblies, checkIfExists: true)

	PROKKA(assemblies_ch)
	PANAROO_QC(PROKKA.out.prokka_ch.collect())
	PANAROO_PANGENOME(PROKKA.out.prokka_ch.collect())
	SNPDIST(PANAROO_PANGENOME.out.core_alignment_ch)
	IQTREE(PANAROO_PANGENOME.out.core_alignment_ch)
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
