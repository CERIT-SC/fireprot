#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.07

requirements:
  InlineJavascriptRequirement: {}

inputs:
  blast_seqs:
    type: File[]
  sequences:
    type: File[]
  factories:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.blast_seqs.map(function(query){return query.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/\\..*\$//"` ;
        SEQSTR="sequences_load_blast_\${ID}.obj"; SEQFILE="";
        for g in $(inputs.sequences.map(function(query){return query.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$SEQSTR") ] ; then SEQFILE="\$g" ; fi
        done
        FACTORYSTR="factory_\${ID}.factory.obj"; FACTORYFILE="";
        for g in $(inputs.factories.map(function(query){return query.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$FACTORYSTR") ] ; then FACTORYFILE="\$g" ; fi
        done
        /usr/bin/java -jar /opt/loschmidt/extractBlastSequences-1.3.1.0.jar "\$f" "\$FACTORYFILE" "\$SEQFILE" ;
      done
outputs:
  full_seqs:
    type: File[]
    outputBinding:
      glob: ./*.fasta
