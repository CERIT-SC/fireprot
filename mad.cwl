#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh

hints:
  DockerRequirement:
    dockerPull: cerit/mad:v0.7
  ResourceRequirement:
    coresMin: 4
    ramMin: 1024

inputs:
  besttree:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
        python3 /usr/local/bin/fix_raxml.py $(inputs.besttree.path) && mad RAxML_bestTree_fixed.T1
outputs:
  besttree_fixed:
    type: File
    outputBinding:
      glob: RAxML_bestTree_fixed.T1
  besttree_rooted:
    type: File
    outputBinding:
      glob: RAxML_bestTree_fixed.T1.rooted
