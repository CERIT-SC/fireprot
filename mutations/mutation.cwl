#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
hints:
  DockerRequirement:
    dockerPull: cerit.io/rosetta:scriptedv0.7
  ResourceRequirement:
    coresMax: 4
    ramMin: 2048
inputs:
  input_dir:
    type: Directory
  renumbered_pdb:
    type: File
  min_cst:
    type: File
  weights:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        python3 /usr/local/bin/mutate $(inputs.input_dir.path) $(inputs.renumbered_pdb.path) $(inputs.min_cst.path) $(inputs.weights.path) && tar czvf outputI.tar.gz iteration_I && tar czvf outputII.tar.gz iteration_II
outputs:
  iterationI:
    type: File
    outputBinding:
      glob: outputI.tar.gz
  iterationII:
    type: File
    outputBinding:
      glob: outputII.tar.gz
