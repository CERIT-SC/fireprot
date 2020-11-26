#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  ScatterFeatureRequirement: {}

steps:
  random:
    run: random.cwl
    scatter: jobname_in
    in:
      jobname_in: input_array
    out: [jobname_out]

inputs: 
  input_array: string[]

outputs: 
  - id: output
    type: 
      type: array
      items: File
    outputSource: random/jobname_out
