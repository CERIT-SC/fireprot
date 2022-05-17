#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/loschmidt:v0.14

requirements:
  InlineJavascriptRequirement: {}

inputs:
  factories:
    type: File[]
  sequences:
    type: File[]
  prefix:
    type: string

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.factories.map(function(query){return query.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/\\..*\$//"` ;
        SEQSTR=".*_\${ID}\\..*"; SEQFILE="";
        for g in $(inputs.sequences.map(function(query){return query.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$SEQSTR") ] ; then SEQFILE="\$g" ; fi
        done
        /opt/openjdk-18/bin/java -jar /opt/loschmidt/saveSequences-1.3.1.0.jar "\$SEQFILE" "\$f" "$(inputs.prefix)" ;
      done
outputs:
  seqs:
    type: File[]
    outputBinding:
      glob: ./*.fasta
