#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["/usr/local/bin/fishSequences.py"]
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot-fishsequences:v0.3
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  pasta_trimmed:
    type: File
    inputBinding:
      position: 0
  sequences:
    type: File
    inputBinding:
      position: 1
outputs:
  filtered_sequences:
    type: File
    outputBinding:
      glob: filteredSequences.fasta
