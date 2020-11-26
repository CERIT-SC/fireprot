#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  ScatterFeatureRequirement: {}

inputs: 
  input_array: string[]

steps:
  random:
    run: random.cwl
    scatter: jobname_in
    in:
      jobname_in: input_array
    out: [jobname_out]

outputs: 
  - id: output
    type: 
      type: array
      items: File
    outputSource: random/jobname_out
