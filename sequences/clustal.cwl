#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["clustalo", "-o", "msa_clustal.fasta", "--threads=1", "-i"]
hints:
  DockerRequirement:
    dockerPull: cerit.io/clustal:v0.2
  ResourceRequirement:
    coresMax: 1
    ramMin: 1024
inputs:
  filtered_sequences:
    type: File
    inputBinding:
      position: 0
outputs:
  msa_clustal:
    type: File
    outputBinding:
      glob: msa_clustal.fasta
