#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.03

requirements:
  InlineJavascriptRequirement: {}

inputs:
  sequences_in:
    type: File[]
  usearch1s:
    type: File[]
  factories:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.sequences_in.map(function(sequence){return sequence.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/\\..*\$//"` ;
        USTR="usearch1_\${ID}.out"; UFILE="";
        for g in $(inputs.usearch1s.map(function(usearch){return usearch.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$USTR") ] ; then UFILE="\$g" ; fi
        done
        FACTORYSTR="factory_\${ID}.factory.obj"; FACTORYFILE="";
        for g in $(inputs.factories.map(function(factory){return factory.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$FACTORYSTR") ] ; then FACTORYFILE="\$g" ; fi
        done
        /usr/bin/java -jar /opt/loschmidt/filterByIdentity-1.3.1.0.jar "\$UFILE" "\$FACTORYFILE" "\$f"
      done

outputs:
  sequences:
    type: File[]
    outputBinding:
      glob: ./*.obj
