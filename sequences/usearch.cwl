#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [usearch, "-id", "0.9", "-centroids", "nr.fasta", "-uc", "clusters.uc", "-cluster_fast"]
hints:
  DockerRequirement:
    dockerPull: cerit.io/usearch:v0.2
  ResourceRequirement:
    coresMin: 2
    ramMin: 1024
inputs:
  strippedSequences:
    type: File
    inputBinding:
      position: 0
outputs:
  clusters:
    type: File
    outputBinding:
      glob: clusters.uc
  nrfasta:
    type: File
    outputBinding:
      glob: nr.fasta
