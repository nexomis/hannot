# Hannot

```
            #################################################
            #    _  _                             _         #
            #   | \| |  ___  __ __  ___   _ __   (_)  __    #
            #   | .` | / -_) \ \ / / _ \ | '  \  | | (_-<   #
            #   |_|\_| \___| /_\_\ \___/ |_|_|_| |_| /__/   #
            #                                               #
            #################################################

 hannot: Homology-based annotation


Typical pipeline command:

  nextflow run nexomis/hannot --prot_fasta /path/to/prot/fa --genome_fasta /path/to/gen/fa --out_dir /path/to/out

Input/output options
  --prot_fasta             [string]  Protein sequence file in FASTA format.
  --genome_fasta           [string]  Genome sequence file in FASTA format.
  --out_dir                [string]  The output directory where the results will be saved.
  --publish_dir_mode       [string]  PublishDir mode for process [default: link]

Annotation options
  --revcomp_from_annot     [boolean] Reverse complement based on annotation. [default: false]
  --regex_prot_name        [string]  Regex pattern to extract protein names from annotations. [default: ^>.*GN=([^ ]+).*$]
  --miniprot_opts          [string]  Options for the Miniprot software. [default: ]

Resources options
  --ncpus_low              [integer] Number of CPUs for low resource processes. [default: 4]
  --ncpus_med              [integer] Number of CPUs for medium resource processes. [default: 8]
  --ncpus_high             [integer] Number of CPUs for high resource processes. [default: 16]
  --biocontainers_registry [string]  Domain for the biocontainers registry. [default: public.ecr.aws]
```