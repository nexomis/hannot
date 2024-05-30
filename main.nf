#!/usr/bin/env nextflow

include { validateParameters; paramsHelp; paramsSummaryLog } from 'plugin/nf-validation'

log.info """
    |            #################################################
    |            #    _  _                             _         #
    |            #   | \\| |  ___  __ __  ___   _ __   (_)  __    #
    |            #   | .` | / -_) \\ \\ / / _ \\ | '  \\  | | (_-<   #
    |            #   |_|\\_| \\___| /_\\_\\ \\___/ |_|_|_| |_| /__/   #
    |            #                                               #
    |            #################################################
    |
    | hannot: Homology-based annotation
    |
    |""".stripMargin()

if (params.help) {
  log.info paramsHelp("nextflow run nexomis/hannot --prot_fasta /path/to/prot/fa --genome_fasta /path/to/gen/fa --out_dir /path/to/out")
  exit 0
}
validateParameters()
log.info paramsSummaryLog(workflow)

include { HANNOT } from './modules/subworkflows/hannot/main.nf'

workflow {
  genomeFasta = Channel.fromPath(params.genome_fasta)
  protFasta = Channel.fromPath(params.prot_fasta)
  HANNOT(genomeFasta, protFasta)
}