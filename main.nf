#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {
	getBed;
	getVcf;
} from "${projectDir}/modules/base.mdl"

workflow {
	println "\nPOPGEN WORKFLOW\n"

	getVcf().view()
}