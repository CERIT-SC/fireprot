#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  ScatterFeatureRequirement: {}

inputs: []

steps:
  random:
    run: random.cwl
    scatter: jobname
    in: []
    out: 
      jobname: output_array

outputs:
  output_array: string[]
