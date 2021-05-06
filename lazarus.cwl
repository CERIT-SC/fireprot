#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh

hints:
  DockerRequirement:
    dockerPull: cerit/lazarus:v0.2
  ResourceRequirement:
    coresMin: 4
    ramMin: 1024
inputs:
  msa_clustal:
    type: File
  besttree_rooted:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        python /home/lazarus/lazarus.py --codeml --model /home/lazarus/paml/dat/lg.dat --branch_length fixed --outputdir . --asrv 4 --alignment $(inputs.msa_clustal.path) --tree $(inputs.besttree_rooted.path) && find . -name 'model.dat' | while read f ; do rm -f "$f" ; done
outputs:
  lazarus:
    type: File
    outputBinding:
      glob: tree_summary.txt
