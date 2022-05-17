#!/usr/bin/env cwl-tes
# flags for ddg 16
#

cwlVersion: v1.0
class: CommandLineTool
baseCommand: bash
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/rosetta:debug
inputs:
  mutations_txt:
    type: File
  pdb_file:
    type: File
  cst_file:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
        /ddg_monomer.static.linuxgccrelease -in:file:s $(inputs.pdb_file.path) -ddg::mut_file $(inputs.mutations_txt.path) -constraints::cst_file $(inputs.cst_file.path) -ddg::minimization_scorefunction "talaris2014.wts" -ddg::iterations 50  -ddg::weight_file soft_rep_design -ddg::local_opt_only false -ddg::min_cst true -ddg::mean false -ddg::min true -ddg::output_silent false -ddg::sc_min_only false -ddg::ramp_repulsive true -fa_max_dis 9.0 -ddg::dump_pdbs true -ignore_unrecognized_res -ddg::minimization_scorefunction /opt/rosetta_bin_linux_2019.35.60890_bundle/main/database/scoring/weights/talaris2014.wts -ddg::minimization_patch -restore_talaris_behavior -database /opt/rosetta_bin_linux_2019.35.60890_bundle/main/database > "stdout" 2> "stderr" && zip mutations.zip mut* && zip repacked.zip repacked*
outputs:
  ddg_predictions_out:
    type: File
    outputBinding:
      glob: ddg_predictions.out
  mutations_pdb_zip:
    type: File
    outputBinding:
      glob: mutations.zip
  repacked_pdb_zip:
    type: File
    outputBinding:
      glob: repacked.zip
  wt_traj:
    type: File
    outputBinding:
      glob: wt_traj
  stdout:
    type: File
    outputBinding:
      glob: stdout
  stderr:
    type: File
    outputBinding:
      glob: stderr
