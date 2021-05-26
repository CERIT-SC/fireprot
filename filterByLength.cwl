#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["/usr/local/bin/filterByLength.py"]
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot-filterbylength:v0.3
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  sequences:
    type: File
    inputBinding:
      position: 0
outputs:
  stripped_sequences:
    type: File
    outputBinding:
      glob: strippedSequences.fasta
