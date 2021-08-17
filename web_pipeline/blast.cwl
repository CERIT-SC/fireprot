#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh

hints:
  DockerRequirement:
    dockerPull: cerit.io/blast:2.8.1-s3

inputs:
  evalue:
    type: string
  query_fasta:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
      cp /root/.s3cfg \${HOME}/.s3cfg && s3cmd sync s3://uniref90 /var/blastdb && blastp -db /var/blastdb/uniref90 -evalue $(inputs.evalue) -max_target_seqs 100000 -outfmt 5 -query $(inputs.query_fasta.path) -out blast.xml -num_threads 10

outputs:
  standard_out:
    type: stdout
  standard_err:
    type: stderr
  blast_xml:
    type: File
    outputBinding:
      glob: blast.xml
