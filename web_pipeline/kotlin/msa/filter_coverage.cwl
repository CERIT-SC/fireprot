#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.12

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
      for f in $(inputs.filtered_seqs_objects.map(function(seq){return seq.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/\\..*\$//"` ;
        FACTORYSTR="factory_\${ID}.factory.obj"; FACTORYFILE="";
        for g in $(inputs.factories.map(function(factory){return factory.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$FACTORYSTR") ] ; then FACTORYFILE="\$g" ; fi
        done
        /usr/bin/java -jar /opt/loschmidt/filterByCoverage-1.3.1.0.jar "\$f" "\$FACTORYFILE"
      done

outputs:
  sequences:
    type: File[]
    outputBinding:
      glob: ./*.obj
