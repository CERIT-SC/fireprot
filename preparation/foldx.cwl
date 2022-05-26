#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/foldx:v0.03
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  pdb:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        mkdir /tmp/calc && ln -sf $(inputs.pdb.path) /tmp/calc/input.pdb && foldx --command=RepairPDB --pdb-dir=/tmp/calc/ --pdb=input.pdb --rotabaseLocation=/usr/local/bin/rotabase.txt --output-dir=.
outputs:
  input_repair:
    type: File
    outputBinding:
      glob: input_Repair.pdb
  input_repair_fxout:
    type: File
    outputBinding:
      glob: input_Repair.fxout
