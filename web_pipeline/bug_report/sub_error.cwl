#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: ubuntu

requirements:
  InlineJavascriptRequirement: {}

inputs:
  input_files:
    type: File[]
  sub1_in:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.typo.map(function(input){return input.path}).join(" ")) ; do
        echo "\$f" >> output_file
      done
      diff $(inputs.sub1_in.path) output_file > diff_file

outputs:
  out_error:
    type: File
    outputBinding:
      glob: diff_file
