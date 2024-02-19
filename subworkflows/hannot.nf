

process RENAME_PROT {
  container "python:3.10"

  label 'cpu_x1'
  label 'mem_2G'

  input:
  path prot_fasta

  output:
  path "renamed_prot.fa"

  script:
  """
  #!/usr/bin/env python3
  import re
  seq_dict = dict()
  seq_name_count = dict()
  with open("${prot_fasta}", "r") as in_file:
    for line in in_file.readlines():
      if line.startswith(">"):
        match = re.match("${params.regex_prot_name}", line)
        name = line.lstrip(">").split()[0]
        if match:
          if len(match.groups()) > 0:
            name = match.groups()[0]
        if name in seq_name_count.keys():
          seq_name_count[name] += 1
          if seq_name_count[name] == 2:
            seq_dict[name + "_1"] = seq_dict[name]
            del seq_dict[name]
          name = name + "_" + str(seq_name_count[name])
        else:
          seq_name_count[name] = 1
        seq_dict[name] = []
      else: 
        seq_dict[name].append(line)
  with open("renamed_prot.fa", "w") as ofile:
    for name, seqs in seq_dict.items():
      ofile.write(f">{name}\\n")
      for seq in seqs:
        ofile.write(seq)
  """
}

process MINIPROT {
  container "${params.biocontainers_registry}/biocontainers/miniprot:0.12--he4a0461_0"

  label 'cpu_x4'
  label 'mem_12G'

  input:
  file genome_fasta
  file prot_fasta

  output:
  path "annot.gff"

  script:
  """
  #!/bin/bash
  miniprot $params.miniprot_opts -t $task.cpus --gff $genome_fasta $prot_fasta > out_annot.gff
  grep -v "##PAF" out_annot.gff > annot.gff
  """
}

process REVCOMP_SEQ {
  container "ghcr.io/nexomis/pandas:py3.11-2.0.3-1.0"

  label 'cpu_x1'
  label 'mem_2G'

  input:
  path genome_fasta
  path annot_file

  output:
  path "revcomp_genome.fa"
  path "revcomp_annot.gff"


  script:
  template "revcomp_seq.py"
}

workflow ALIGN_AND_HANNOT {
    take:
    genomeFasta
    proteinFasta

    main:

    RENAME_PROT(proteinFasta)
    | set {renamedProt}

    MINIPROT(genomeFasta, renamedProt)
    | set {annotFile}

    if (params.revcomp_from_annot) {
      REVCOMP_SEQ(genomeFasta, annotFile)
      out_genome_file = REVCOMP_SEQ.out[0]
      out_annot_file = REVCOMP_SEQ.out[1]
    } else {
      out_genome_file = genomeFasta
      out_annot_file = annotFile
    }

    emit:
    genome_file = out_genome_file
    annot_file = out_annot_file

}
