#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/loschmidt:v0.21

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
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/\\..*\$//"` ;
        FACTSTR="factory_\${ID}.factory.obj"; FACTFILE="";
        for g in $(inputs.msa_factories.map(function(query){return query.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$FACTSTR") ] ; then FACTFILE="\$g" ; fi
        done
        /opt/openjdk-18/bin/java -jar /opt/loschmidt/loadBlast-1.3.1.0.jar "\$f" "\$FACTFILE" ;
      done
outputs:
  blast_ids:
    type: File[]
    outputBinding:
      glob: ./*.txt
  sequences:
    type: File[]
    outputBinding:
      glob: ./*.obj
