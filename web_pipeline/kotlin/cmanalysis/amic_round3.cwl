#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot-amic:v0.2

inputs:
  mis:
    type: File[]
  entfacts:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.mis.map(function(mi){return mi.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/\\..*\$//"` ;
        ENTFILE="";
        for g in $(inputs.entfacts.map(function(entfact){return entfact.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\${ID}.out") ] ; then ENTFILE="\$g" ; fi
        done
        /opt/amic/MI.+res.py -v 3 "\$f" "\$ENTFILE" > "round_3_\${ID}.out" ;
      done

outputs:
  outputs:
    type: File[]
    outputBinding:
      glob: ./*.out
