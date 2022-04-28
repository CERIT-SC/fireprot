#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/usr/bin/pdftex, -interaction=nonstopmode]
hints:
  DockerRequirement:
    dockerPull: texlive/texlive:latest
inputs:
  output_tex:
    type: File
    inputBinding:
      position: 0

outputs:
  output_pdf:
    type: File
    outputBinding:
      glob: output.pdf

