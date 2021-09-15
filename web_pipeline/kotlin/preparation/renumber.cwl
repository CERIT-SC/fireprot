#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
hints:
  DockerRequirement:
    dockerPull: cerit.io/rosetta:latest
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  pdb_hetatm:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        pdb_renumbering.py $(inputs.pdb_hetatm.path) >> input_Renumbered.pdb
outputs:
  input_renumbered:
    type: File
    outputBinding:
      glob: input_Renumbered.pdb
