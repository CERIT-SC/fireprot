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
    dockerPull: cerit.io/rosetta:latest
  ResourceRequirement:
    coresMin: 20
    coresMax: 25
    ramMin: 20480
    ramMax: 80480
    tmpdirMin: 1024
    tmpdirMax: 16384
    outdirMin: 1024
    outdirMax: 16384
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
        ddg_monomer.static.linuxgccrelease -in:file:s $(inputs.pdb_file.path) -ddg::mut_file $(inputs.mutations_txt.path) -constraints::cst_file $(inputs.cst_file.path) -ddg::minimization_scorefunction "talaris2014.wts" -ddg::iterations 50  -ddg::weight_file soft_rep_design -ddg::local_opt_only false -ddg::min_cst true -ddg::mean false -ddg::min true -ddg::output_silent false -ddg::sc_min_only false -ddg::ramp_repulsive true -fa_max_dis 9.0 -ddg::dump_pdbs true -ignore_unrecognized_res -ddg::minimization_scorefunction /opt/rosetta_bin_linux_2019.35.60890_bundle/main/database/scoring/weights/talaris2014.wts -ddg::minimization_patch -restore_talaris_behavior > "stdout" 2> "stderr" || exit \$?
outputs:
  ddg_predictions_out:
    type: File
    outputBinding:
      glob: ddg_predictions.out
  stdout:
    type: File
    outputBinding:
      glob: stdout
  stderr:
    type: File
    outputBinding:
      glob: stderr
