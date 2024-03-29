#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
hints:
  DockerRequirement:
    dockerPull: alpine:latest
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  rossetta_out:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        grep c-alpha $(inputs.rossetta_out.path) | awk '{print \"AtomPair CA \"$7\" CA \"$9\" HARMONIC \"$11\" \"$14}' > min.cst
outputs:
  min_cst:
    type: File
    outputBinding:
      glob: min.cst
