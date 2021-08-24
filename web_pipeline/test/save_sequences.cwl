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
  sequences:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.msa_factories.map(function(query){return query.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*msa_//" | sed "s/.factory\$//"` ;
        SEQSTR="sequences_\${ID}.out"; SEQFILE="";
        for g in $(inputs.sequences.map(function(query){return query.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$SEQSTR") ] ; then SEQFILE="\$g" ; fi
        done
        /usr/local/bin/web_scripts/savesequences.py "\$f" "\$SEQFILE" ; done
outputs:
  blast_seqs:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*.fasta
