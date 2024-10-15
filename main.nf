#!/usr/bin/env nextflow
nextflow.preview.output = true
include { validateParameters; paramsHelp; paramsSummaryLog; fromSamplesheet } from 'plugin/nf-validation'
include { showSchemaHelp; extractType } from './modules/config/schema_helper.nf'

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
  log.info showSchemaHelp("assets/input_schema.json")
  log.info showSchemaHelp("assets/prot_schema.json")
  exit 0
}

validateParameters()
log.info paramsSummaryLog(workflow)

include { HANNOT } from './modules/subworkflows/hannot/main.nf'

workflow {

  Channel.fromSamplesheet("input")
  | map {
    [[
      id: it[0],
      proteome_id: it[2],
      filter_annot: it[3], 
      revcomp: it[4],
      retain_only_annot: it[5]
    ], file(it[1])]
  }
  | set {genomeFasta}

  Channel.fromSamplesheet("prot")
  | map {[[id: it[0], regex_prot_name: it[2]], file(it[1])]}
  | set {protFasta}

  HANNOT(genomeFasta, protFasta)

  publish:
  HANNOT.out.raw_annot >> 'miniprot'
  HANNOT.out.genome >> 'annotation'
  HANNOT.out.annot >> 'annotation'
}

output {
  directory "${params.out_dir}"
  mode params.publish_dir_mode
}
