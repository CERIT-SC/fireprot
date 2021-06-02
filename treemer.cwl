#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
hints:
  DockerRequirement:
    dockerPull: cerit.io/treemer:v0.3
  ResourceRequirement:
    coresMin: 8
    ramMin: 1024
inputs:
  pasta_tree:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        ln -sf $(inputs.pasta_tree.path) pastaTree.tre && python /home/user/Treemmer/Treemmer.py -X 150 -c 8 pastaTree.tre
outputs:
  pasta_tree_trimmed_list:
    type: File
    outputBinding:
      glob: pastaTree.tre_trimmed_list_X_150
  everything:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*
