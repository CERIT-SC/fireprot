#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh 

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: cerit.io/usearch:v0.2

inputs:
  filtered_seqs:
    type: File[]
  clusteringthreshold:
    type: double

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.queries_fasta.map(function(query){return query.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/.fasta\$//"` ;
        /usr/bin/usearch -cluster_fast "\$f" -id $(inputs.clusteringthreshold) -uc "usearch2_\${ID}.out" ; done
outputs:
  userach2_outs:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*.out
