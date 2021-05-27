#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
hints:
  DockerRequirement:
    dockerPull: cerit.io/raxml:v0.5
  ResourceRequirement:
    coresMin: 12
    ramMin: 4096
inputs:
  msa_clustal:
    type: File
  iqtree:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        raxml -C -f a -s $(inputs.msa_clustal.path) -n T1 -m "\$(python3 /usr/local/bin/best_tree_model.py $(inputs.iqtree.path))" -p 12345 -x 12345 -# 50 -T 12
outputs:
  besttree:
    type: File
    outputBinding:
      glob: RAxML_bestTree.T1
