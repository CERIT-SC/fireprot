#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh 

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/usearch:v0.2

inputs:
  filtered_seqs:
    type: File[]
  clusteringthreshold:
    type: double

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.filtered_seqs.map(function(seq){return seq.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/.fasta\$//"` ;
        /usr/bin/usearch -cluster_fast "\$f" -id $(inputs.clusteringthreshold) -uc "usearch2_\${ID}.out" ;
      done
outputs:
  usearch2_outs:
    type: File[]
    outputBinding:
      glob: ./*.out
