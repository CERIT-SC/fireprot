#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot-amic:v0.1

inputs:
  queries:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.queries.map(function(query){return query.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/\\..*\$//"` ;
        /opt/amic/MI.+res.py -v 2 -G 0.5 --initidx=1 -q query "\$f" > "round_2_\${ID}.out" ;
      done

outputs:
  outputs:
    type: File[]
    outputBinding:
      glob: ./*.out
