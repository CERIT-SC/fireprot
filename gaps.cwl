#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["/usr/local/bin/gapCorrection.py"]
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot-gapcorrection:v0.7
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  msa_clustal:
    type: File
    inputBinding:
      position: 0
  combined_tree:
    type: File
    inputBinding:
      position: 1
  nodes:
    type: File[]
    inputBinding:
      position: 2
outputs:
  nodes:
    type: File[]
    outputBinding:
      glob: nodes/*.dat
