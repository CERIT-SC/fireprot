#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["/usr/local/bin/createClustered.py"]
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot-createclustered:v0.4
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  clusters:
    type: File
    inputBinding:
      position: 0
  stripped_sequences:
    type: File
    inputBinding:
      position: 1
outputs:
  clustered_sequences:
    type: File
    outputBinding:
      glob: sequencesClustered.fasta
