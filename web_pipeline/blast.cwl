#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: cerit.io/blast:2.8.1-s3.2

inputs:
  evalue:
    type: string
  query_fasta:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      cp /root/.s3cfg \${HOME}/.s3cfg && s3cmd sync s3://uniref90 \${HOME}/blastdb &&
      for f in $(inputs.query_fasta.map(function(query){return query.path}).join(" ")) ; do
      ID=`echo "\$f" | sed "s/.*query_//" | sed "s/.fasta\$//"` ;
      blastp -db \${HOME}/blastdb/uniref90 -evalue $(inputs.evalue) -max_target_seqs 100000 -outfmt 5 -query "\${f}" -out "blast_\${ID}.xml" -num_threads 10 ; done ; rm -Rf \${HOME}/blastdb

outputs:
  standard_out:
    type: stdout
  standard_err:
    type: stderr
  blast_xmls:
    type: File[]
    outputBinding:
      glob: blast_*.xml
