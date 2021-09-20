#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot-freecontact:v0.1

inputs:
  alignments:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.alignments.map(function(alignment){return alignment.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/\\..*\$//"` ;
        /usr/bin/freecontact -a 4 < "\$f" > "freecontact_\${ID}.dca" ;
      done

outputs:
  freecontacts:
    type: File[]
    outputBinding:
      glob: ./*.dca
