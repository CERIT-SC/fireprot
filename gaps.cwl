#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["/usr/local/bin/gapCorrection.py"]
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot-gapcorrection:v0.4
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
outputs:
  nodes:
    type: Directory
    outputBinding:
      glob: *
