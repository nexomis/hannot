if ( params.help ) {
  help = """
    | ------------------------------------------------------------
    |hannot: A simple workflow to perform homology-assisted annotation
    |
    |Required arguments:
    |  --genome_fasta   Fasta file for the genome to be annotated
    |  --prot_fasta     Fasta file for the potentially homolog proteins. 
    |                     Homologs are supposed to be distant or else there will
    |                     double annotation of the same region.
    |  --out_dir        Output directory
    |
    |Optional arguments:
    |  --regex_prot     Regex to extract replace gene name in the give fasta
    |                     file default is adapted to uniprot formatted files.
    |
  """.stripMargin()
  // Print the help with the stripped margin and exit
  println(help)
  exit(0)
}

// Validate input parameters
if (params.genome_fasta == null) {
  error """--genome_fasta is mandatory""".stripMargin()
}
if (params.prot_fasta == null) {
  error """--prot_fasta is mandatory""".stripMargin()
}
if (params.out_dir == null) {
  error """--out_dir is mandatory""".stripMargin()
}

include { ALIGN_AND_HANNOT } from './subworkflows/hannot'

process PUBLISH {
  container 'debian:stable-slim'

  input:
  path genome_fasta
  path annot_fasta

  script:
  """
  #!/usr/bin/env bash
  mkdir -p annotation
  mv $genome_fasta annotation/genome.fasta
  mv $annot_fasta annotation/annot.gff
  """

  output:
  path "annotation/*"

  publishDir "$params.out_dir", mode: 'copy'
}

workflow {
  genomeFasta = Channel.fromPath(params.genome_fasta)
  protFasta = Channel.fromPath(params.prot_fasta)
  ALIGN_AND_HANNOT(genomeFasta, protFasta)
  PUBLISH(ALIGN_AND_HANNOT.out.genome_file, ALIGN_AND_HANNOT.out.annot_file)
}