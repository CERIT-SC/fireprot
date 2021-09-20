#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
requirements:
    InlineJavascriptRequirement: {}
inputs:
  input_files:
    type: File[]
outputs:
  working_out:
    type: File
    outputSource: sub_working/out_working
  error_out:
    type: File
    outputSource: sub_error/out_error
  unreachable_out:
    type: File
    outputSource: sub_unreachable/unreachable_out

steps:
  sub_working:
    run: sub_working.cwl
    in:
      input_files: input_files
    out: [out_working]
  sub_error:
    run: sub_error.cwl
    in:
      input_files: input_files
      sub1_in: sub_working/out_working
    out: [out_error]
  sub_unreachable:
    run: sub_unreachable.cwl
    in:
      error_in: sub_error/out_error
    out: [unreachable_out]
