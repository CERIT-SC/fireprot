#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/rosetta:latest
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  input_renumbered:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        echo $(inputs.input_renumbered.path) > renumbered_path.txt && minimize_with_cst.static.linuxgccrelease -in:file:l renumbered_path.txt -in:file:fullatom -ignore_unrecognized_res -fa_max_dis 9.0 -ddg:harmonic_ca_tether 0.5 -score:weights /opt/rosetta_bin_linux_2019.35.60890_bundle/main/database/scoring/weights/talaris2014.wts -ddg::constraint_weight 1.0 -ddg::sc_min_only false -ddg:out_pdb_prefix out -score:patch > rossetta.out
outputs:
  rossetta_out:
    type: File
    outputBinding:
      glob: rossetta.out
  input_renumbered_out:
    type: File
    outputBinding:
      glob: out.input_Renumbered_0001.pdb
