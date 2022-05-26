#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
requirements:
    InlineJavascriptRequirement: {}
    MultipleInputFeatureRequirement: {}
inputs:
  old_obj:
    type: File
  new_obj:
    type: File
  job_config:
    type: File
  indexes:
    type: File
outputs:
  fodors:
    type: File[]
    outputSource: generate_files/fodors
  freecontacts:
    type: File[]
    outputSource: generate_files/freecontacts
  amic_round1_outputs:
    type: File[]
    outputSource: amic_round1/outputs
  amic_round2_outputs:
    type: File[]
    outputSource: amic_round2/outputs
  amic_round3_outputs:
    type: File[]
    outputSource: amic_round3/outputs
  amic_parser_old:
    type: File
    outputSource: amic_parser/amic_old
  freecontacts_dca:
    type: File[]
    outputSource: freecontact/freecontacts
  csvs:
    type: File[]
    outputSource: end/csvs
  cma_old:
    type: File
    outputSource: end/cmanalysis_old
  cma_new:
    type: File
    outputSource: end/cmanalysis_new

steps:
  generate_files:
    run: cmanalysis/generate_files.cwl
    in:
      old_obj: old_obj
      new_obj: new_obj
    out: [fodors, freecontacts]
  amic_round1:
    run: cmanalysis/amic_round1.cwl
    in:
      queries: generate_files/fodors
    out: [outputs]
  amic_round2:
    run: cmanalysis/amic_round2.cwl
    in:
      queries: generate_files/fodors
    out: [outputs]
  amic_round3:
    run: cmanalysis/amic_round3.cwl
    in:
      mis: amic_round1/outputs
      entfacts: amic_round2/outputs
    out: [outputs]
  amic_parser:
    run: cmanalysis/amic_parser.cwl
    in:
      old_obj: old_obj
      amic_outputs: amic_round3/outputs
    out: [amic_old]
  freecontact:
    run: cmanalysis/freecontact.cwl
    in:
      alignments: generate_files/freecontacts
    out: [freecontacts]
  end:
    run: cmanalysis/end.cwl
    in:
      old_obj: amic_parser/amic_old
      new_obj: new_obj
      job_config: job_config
      indexes: indexes
    out: [cmanalysis_old, cmanalysis_new, csvs]
