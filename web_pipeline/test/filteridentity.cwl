#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireweb:v0.11

inputs:
  sequences:
    type: File[]
  usearch1s:
    type: File[]
  maxidentity:
    type: double

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.sequences.map(function(query){return query.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*sequences_//" | sed "s/.out\$//"` ;
        USTR="usearch1_\${ID}.out"; UFILE="";
        for g in $(inputs.usearch1s.map(function(query){return query.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$USTR") ] ; then UFILE="\$g" ; fi
        done
        /usr/local/bin/web_scripts/filteridentity.py "\$f" "\$UFILE" "$(inputs.maxidentity)"
      done

outputs:
  sequences:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*.out
