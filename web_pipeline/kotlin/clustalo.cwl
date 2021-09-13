#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh 

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: cerit.io/clustal:v0.2

inputs:
  coverage_fasta:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.queries_fasta.map(function(query){return query.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/.fasta\$//"` ;
        /usr/local/bin/clustalo -i "\$f" -o "msa_\${ID}.out" --force ; done
outputs:
  clustalo_outs:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*.out
