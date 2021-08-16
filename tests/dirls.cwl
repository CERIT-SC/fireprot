#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh

hints:
  DockerRequirement:
    dockerPull: ubuntu

inputs:
  dir:
    type: Directory

arguments:
  - prefix: -c
    valueFrom: |
        ls -lah $(inputs.dir.path)
outputs:
  standard:
    type: stdout
