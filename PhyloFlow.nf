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
	publishDir "${params.outdir}", pattern: "core.full.aln", mode: "copy"	
	publishDir "${params.outdir}", pattern: "core.txt", mode: "copy"
	publishDir "${params.outdir}/logs", pattern: "snippy.log", mode: "copy"

	label 'medium'

	input:
	file("*")

	output:
	file("core.full.aln")

	script:
	"""
	$baseDir/bin/snippyfy.bash
	snippy-multi snippy_samples.list --ref $params.snippyref --cpus $task.cpus > snippy.sh
	sh snippy.sh &> snippy.log
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
	publishDir "${params.outdir}", pattern: "snp_dists.tab", mode: "copy"
	
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
	file("*.gff")

	script:
	"""
	prokka --addgenes --compliant --prefix $assembly.baseName --outdir . --force $assembly
	"""
}

process PANAROO_QC {
	conda "/cluster/projects/nn9305k/src/miniconda/envs/Panaroo"
	publishDir "${params.outdir}", pattern: "*.png", mode: "copy"
	publishDir "${params.outdir}", pattern: "mash_dist.txt", mode: "copy"
	publishDir "${params.outdir}/logs", pattern: "panaroo_qc.log", mode: "copy"

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
	publishDir "${params.outdir}", pattern: "core_gene_alignment.aln", mode: "copy"
	publishDir "${params.outdir}", pattern: "summary_statistics.txt", mode: "copy"
	publishDir "${params.outdir}/logs", pattern: "panaroo_pangenome.log", mode: "copy"

	label 'heavy'

        input:
        file(gffs)

        output:
        file("core_gene_alignment.aln")

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

workflow CORE_PHYLO {
	assemblies_ch=channel.fromPath(params.assemblies, checkIfExists: true)

	PROKKA(assemblies_ch)
	PANAROO_QC(PROKKA.out.collect())
	PANAROO_PANGENOME(PROKKA.out.collect())
	SNPDIST(PANAROO_PANGENOME.out)
	IQTREE(PANAROO_PANGENOME.out)
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
