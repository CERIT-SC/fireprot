#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
inputs:
  pdb:
    type: File
  rotobase:
    type: File
  weights:
    type: File
  mutation_dir_tar:
    type: File
outputs:
  foldx_repair:
    type: File
    outputSource: foldx/input_repair
  foldx_repair_fxout:
    type: File
    outputSource: foldx/input_repair_fxout
  renumber_out:
    type: File
    outputSource: renumber/input_renumbered
  minimize_rossetta:
    type: File
    outputSource: minimize/rossetta_out
  minimize_renumbered:
    type: File
    outputSource: minimize/input_renumbered_out
  filter_out:
    type: File
    outputSource: filter/min_cst
  mutation_I:
    type: File
    outputSource: mutation/iterationI
  mutation_II:
    type: File
    outputSource: mutation/iterationII

steps:
  foldx:
    run: foldx.cwl
    in:
      pdb: pdb
      rotobase: rotobase
    out: [input_repair, input_repair_fxout]
  renumber:
    run: renumber.cwl
    in:
      input_repair: foldx/input_repair
    out: [input_renumbered]
  minimize:
    run: minimize.cwl
    in:
      input_renumbered: renumber/input_renumbered
      weights: weights
    out: [rossetta_out, input_renumbered_out]
  filter:
    run: filter.cwl
    in:
      rossetta_out: minimize/rossetta_out
    out: [min_cst]
  mutation:
    run: mutation.cwl
    in:
      input_dir_tar: mutation_dir_tar
      renumbered_pdb: renumber/input_renumbered
      min_cst: filter/min_cst
      weights: weights
    out: [iterationI, iterationII]
