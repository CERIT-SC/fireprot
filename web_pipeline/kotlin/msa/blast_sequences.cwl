#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/blast:2.8.1-s3.3

inputs:
  blast_ids:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      cp /root/.s3cfg \${HOME}/.s3cfg && s3cmd sync s3://uniref90 \${HOME}/blastdb &&
      for f in $(inputs.blast_ids.map(function(query){return query.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/\\..*//"` ;
        blastdbcmd -db \${HOME}/blastdb/uniref90 -entry_batch "\${f}" -out "seqs_\${ID}.fasta" ;
      done ;
      rm -Rf \${HOME}/blastdb

outputs:
  blast_sequences:
    type: File[]
    outputBinding:
      glob: ./*.fasta
