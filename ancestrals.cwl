#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["/usr/local/bin/parseAncestrals.py"]
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot-parseancestrals:v0.1
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  nodes:
    type: File[]
    inputBinding:
      position: 0
outputs:
  ancestrals:
    type: File[]
    outputBinding:
      glob: ancestrals/*.dat
