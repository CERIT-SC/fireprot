#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: ubuntu

inputs:
  query_fasta:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.query_fasta.map(function(query){return query.path}).join(" ")) ; do
      ID=`echo "\$f" | sed "s/.*query_//" | sed "s/.fasta\$//"` ;
      touch "blast_\${ID}.xml" ; done

outputs:
  blast_xmls:
    type: File[]
    outputBinding:
      glob: ./blast_*.xml
