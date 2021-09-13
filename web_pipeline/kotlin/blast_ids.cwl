#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.02

requirements:
  InlineJavascriptRequirement: {}

inputs:
  msa_factories:
    type: File[]
  blast_xmls:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.blast_xmls.map(function(query){return query.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/.xml\$//"` ;
        MSASTR="factory_\${ID}.obj"; MSAFILE="";
        for g in $(inputs.msa_factories.map(function(query){return query.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$MSASTR") ] ; then MSAFILE="\$g" ; fi
        done
        /usr/bin/java -jar /opt/loschmidt/loadBlast-1.3.1.0.jar "\$f" "\$MSAFILE" ; done
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
      glob: ./*.obj
