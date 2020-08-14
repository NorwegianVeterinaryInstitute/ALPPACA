// PhyloFlow Pipeline

// Channels
Channel
	.fromPath(params.assemblies, checkIfExists: true)
	.collect()
	.set { assemblies_ch }


// Processes
process PARSNP {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/ParSNP"
	publishDir "${params.outdir}/logs", pattern: "parsnp.log", mode: "copy"
	publishDir "${params.outdir}", pattern: "results/parsnpAligner.log", mode: "copy"

	label 'regular'

	input:
	file("*") from assemblies_ch

	output:
	file("*")
	file("results/*.xmfa") into convert_ch

	script:
	"""
	parsnp -d *.fasta -p 4 -o results -r $params.parsnp_ref -v -c &> parsnp.log
	"""
}

process CONVERT {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Harvesttools"
	publishDir "${params.outdir}", pattern: "parsnp_alignment.fasta", mode: "copy"

	input:
	file(xmfa) from convert_ch

	output:
	file("*")
	file("parsnp_alignment.fasta") into gubbins_ch

	script:
	"""
	harvesttools -x $xmfa -M parsnp_alignment.fasta
	"""

}

process GUBBINS {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Gubbins"
	publishDir "${params.outdir}/logs", pattern: "gubbins.log", mode: "copy"
	publishDir "${params.outdir}", pattern: "*filtered_polymorphic_sites.fasta", mode: "copy"
	publishDir "${params.outdir}", pattern: "parsnp_alignment.per_branch_statistics.csv", mode: "copy"

	label 'regular'
	
	input:
	file(alignment) from gubbins_ch

	output:
	file("*")
	file("*filtered_polymorphic_sites.fasta") into (iqtree_ch, snpdist_ch)
	
	script:
	"""
	run_gubbins.py $alignment -t $params.treebuilder -r $params.gubbinsmodel --threads $task.cpus -v &> gubbins.log
	"""
}

process IQTREE {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/IQTree"
	publishDir "${params.outdir}/logs", pattern: "iqtree.log", mode: "copy"
	publishDir "${params.outdir}", pattern: "iqtree.contree", mode: "copy"
	publishDir "${params.outdir}", pattern: "iqtree.iqtree", mode: "copy"

	label 'regular'	

	input:
	file(alignment_filtered) from iqtree_ch

	output:
	file("*")

	script:
	"""
	iqtree -s $alignment_filtered -m $params.iqtree_model -bb $params.bootstrap -nt AUTO -pre iqtree -v &> iqtree.log
	"""
}

process SNPDIST {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/snp-dists"
	publishDir "${params.outdir}", pattern: "gubbins_snp_dists.tab", mode: "copy"
	
	input:
	file(snp_alignment) from snpdist_ch

	output:
	file("*")

	script:
	"""
	snp-dists $snp_alignment > gubbins_snp_dists.tab
	"""
}
