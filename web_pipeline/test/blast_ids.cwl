#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh 

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireweb:v0.03

inputs:
  msa_factories:
    type: File[]
  blast_xmls:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.blast_xmls.map(function(query){return query.path}).join(" ")) ; do
      ID=`echo "\$f" | sed "s/.*blast_//" | sed "s/.xml\$//"` ;
      /usr/local/bin/web_scripts/blastloader.py "$f" "msa_\${ID}.factory" ; done
outputs:
  blast_ids:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*.txt
