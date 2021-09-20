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
  error_in:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
      cat $(inputs.error_in.path)
      echo "I will never see the light of day :("

outputs:
  unreachable_out:
    type: stdout
