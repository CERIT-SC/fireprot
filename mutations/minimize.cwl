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
  input_renumbered:
    type: File
  weights:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        echo $(inputs.input_renumbered.path) > renumbered_path.txt && minimize_with_cst.static.linuxgccrelease -in:file:l renumbered_path.txt -in:file:fullatom -ignore_unrecognized_res -fa_max_dis 9.0 -ddg:harmonic_ca_tether 0.5 -score:weights $(inputs.weights.path) -ddg::constraint_weight 1.0 -ddg::sc_min_only false -ddg:out_pdb_prefix out -score:patch > rosetta.out
outputs:
  rosetta_out:
    type: File
    outputBinding:
      glob: rosetta.out
  input_renumbered_out:
    type: File
    outputBinding:
      glob: out.input_Renumbered_0001.pdb
