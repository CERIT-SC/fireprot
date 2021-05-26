#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["run_pasta.py", "-d", "Protein", "-j", "pastaTree",  "--num-cpus=8", "-o",  ".", "-i"]
hints:
  DockerRequirement:
    dockerPull: cerit.io/pasta:v0.3
  ResourceRequirement:
    coresMin: 8
    ramMin: 1024
inputs:
  sequencesClustered:
    type: File
    inputBinding:
      position: 0
outputs:
  pasta_tree:
    type: File
    outputBinding:
      glob: pastaTree.tre
