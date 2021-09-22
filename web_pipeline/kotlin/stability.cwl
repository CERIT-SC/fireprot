#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
requirements:
    InlineJavascriptRequirement: {}
inputs:
  new_obj:
    type: File
  minimized_pdb:
    type: File
outputs:
  foldx_batches:
    type: File[]
    outputSource: foldx_start/foldx_batches
  foldx_averages:
    type: File[]
    outputSource: foldx_parse/averages
  foldx_fxouts:
    type: File[]
    outputSource: foldx_parse/fxouts

steps:
  foldx_start:
    run: stability/foldx_start.cwl
    in:
      new_obj: new_obj
    out: [foldx_batches]
  foldx_parse:
    run: stability/foldx_parse.cwl
    in:
      batches: foldx_start/foldx_batches
      pdb: minimized_pdb
    out: [averages, fxouts]
