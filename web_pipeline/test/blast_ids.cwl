#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh 

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireweb:v0.10

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
        MSASTR="msa_\${ID}.factory"; MSAFILE="";
        for g in $(inputs.msa_factories.map(function(query){return query.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$MSASTR") ] ; then MSAFILE="\$g" ; fi
        done
        /usr/local/bin/web_scripts/blastloader.py "\$f" "\$MSAFILE" ; done
outputs:
  blast_ids:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*.txt
  sequences:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*.out
