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
  mutation_dir:
    type: Directory
outputs:

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
    out: [rosetta_out, input_renumbered_out]
  filter:
    run: filter.cwl
    in:
      rosetta_out: minimize/rosetta_out
    out: [min_cst]
  mutation:
    run: mutation.cwl
    in:
      input_dir: mutation_dir
      renumbered_pdb: renumber/input_renumbered
      min_cst: filter/min_cst
      weights: weights
    out: [iterationI, iterationII]
