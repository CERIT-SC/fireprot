#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: bash
hints:
  DockerRequirement:
    dockerPull: texlive/texlive:latest
inputs:
  output_tex:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
        /usr/bin/pdftex -interaction=nonstopmode $(inputs.output_tex.path); [ -f output.pdf ]

outputs:
  output_pdf:
    type: File
    outputBinding:
      glob: output.pdf

