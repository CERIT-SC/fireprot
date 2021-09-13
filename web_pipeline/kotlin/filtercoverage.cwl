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
  filtered_seqs_objects:
    type: File[]
  factories:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.filtered_seqs_objects.map(function(query){return query.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/.out\$//"` ;
        FACTORYSTR="factory_\${ID}.obj"; FACTORYFILE="";
        for g in $(inputs.factories.map(function(query){return query.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$FACTORYSTR") ] ; then FACTORYFILE="\$g" ; fi
        done
        /usr/bin/java -jar /opt/loschmidt/filterByCoverage-1.3.1.0.jar "\$f" "\$FACTORYFILE"
      done

outputs:
  sequences:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*.out
