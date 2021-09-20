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

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.input_files.map(function(input){return input.path}).join(" ")) ; do
        echo "\$f" >> output_file
      done

outputs:
  out_working:
    type: File
    outputBinding:
      glob: output_file
