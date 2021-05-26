#/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["iqtree", "-m", "TESTONLY", "-pre", "msa_clustal", "-s"]
hints:
  DockerRequirement:
    dockerPull: cerit.io/iqtree:v0.4
  ResourceRequirement:
    coresMin: 1
    ramMin: 1024
inputs:
  msa_clustal:
    type: File
    inputBinding:
      position: 0
outputs:
  iqtree:
    type: File
    outputBinding:
      glob: msa_clustal.iqtree
