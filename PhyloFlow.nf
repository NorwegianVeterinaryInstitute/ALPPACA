// PhyloFlow Pipeline

// Activate dsl2
nextflow.enable.dsl=2

// Processes
process PARSNP {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/ParSNP"
	publishDir "${params.outdir}/logs", pattern: "*.log", mode: "copy"
	publishDir "${params.outdir}", pattern: "results/*.log", mode: "copy"

	label 'regular'

	input:
	file("*")

	output:
	file("results/*.xmfa")

	script:
	"""
	parsnp -d *.fasta -p 4 -o results -r $params.parsnp_ref -v -c &> parsnp.log
	"""
}

process SNIPPY {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Snippy"
	
	label 'medium'

	input:
	file("*")

	output:
	file("core.full.aln")

	script:
	"""
	$baseDir/bin/snippyfy.bash
	snippy-multi snippy_samples.list --ref $params.snippyref --cpus $task.cpus > snippy.sh
	sh snippy.sh
	"""
}

process CONVERT {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Harvesttools"
	publishDir "${params.outdir}", pattern: "parsnp_alignment.fasta", mode: "copy"

	input:
	file(xmfa)

	output:
	file("parsnp_alignment.fasta")

	script:
	"""
	harvesttools -x $xmfa -M parsnp_alignment.fasta
	"""

}

process GUBBINS {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Gubbins"
	publishDir "${params.outdir}/logs", pattern: "gubbins.log", mode: "copy"
	publishDir "${params.outdir}", pattern: "*filtered_polymorphic_sites.fasta", mode: "copy"
	publishDir "${params.outdir}", pattern: "*per_branch_statistics.csv", mode: "copy"

	label 'regular'
	
	input:
	file(alignment)

	output:
	file("*filtered_polymorphic_sites.fasta")
	
	script:
	"""
	run_gubbins.py $alignment -t $params.treebuilder -r $params.gubbinsmodel --threads $task.cpus -v &> gubbins.log
	"""
}

process IQTREE {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/IQTree"
	publishDir "${params.outdir}/logs", pattern: "*.log", mode: "copy"
	publishDir "${params.outdir}", pattern: "*.contree", mode: "copy"
	publishDir "${params.outdir}", pattern: "*.iqtree", mode: "copy"

	label 'regular'	

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
	publishDir "${params.outdir}", pattern: "gubbins_snp_dists.tab", mode: "copy"
	
	input:
	file(snp_alignment)

	output:
	file("*")

	script:
	"""
	snp-dists $snp_alignment > gubbins_snp_dists.tab
	"""
}


// workflows

workflow PARSNP_PHYLO {
	assemblies_ch=channel.fromPath(params.assemblies, checkIfExists: true)
			     .collect()

	PARSNP(assemblies_ch)
	CONVERT(PARSNP.out)
	GUBBINS(CONVERT.out)
	SNPDIST(CONVERT.out)
	IQTREE(GUBBINS.out)
}

workflow SNIPPY_PHYLO {
	reads_ch=channel.fromPath(params.reads, checkIfExists: true)
                        .collect()

        SNIPPY(reads_ch)
        GUBBINS(SNIPPY.out)
        SNPDIST(SNIPPY.out)
        IQTREE(GUBBINS.out)
}

workflow {
if (params.snippy) {
	SNIPPY_PHYLO()
	}

if (!params.snippy) {
	PARSNP_PHYLO()
	}
}
