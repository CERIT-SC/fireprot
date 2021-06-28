#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["/usr/local/bin/combineTrees.py"]
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot-combinetrees:v0.3
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  tree:
    type: File
    inputBinding:
      position: 0
outputs:
  combined_tree:
    type: File
    outputBinding:
      glob: combined.tre
