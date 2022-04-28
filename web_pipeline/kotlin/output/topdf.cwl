#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: bash
hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt-pdf:v0.01
inputs:
  output_tex:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
        /usr/bin/pdflatex -interaction=nonstopmode $(inputs.output_tex.path)

outputs:
  output_pdf:
    type: File
    outputBinding:
      glob: output.pdf

