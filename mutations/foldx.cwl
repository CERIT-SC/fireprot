#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
hints:
  DockerRequirement:
    dockerPull: cerit.io/foldx:latest
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  pdb:
    type: File
  rotobase:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        mkdir /tmp/calc && ln -sf $(inputs.pdb.path) /tmp/calc/input.pdb && foldx --command=RepairPDB --pdb-dir=/tmp/calc/ --pdb=input.pdb --rotabaseLocation=$(inputs.rotobase.path) --output-dir=/tmp/calc
outputs:
  input_repair:
    type: File
    outputBinding:
      glob: /tmp/calc/input_Repair.pdb
