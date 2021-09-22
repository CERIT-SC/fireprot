#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/usr/bin/java, -jar, /opt/loschmidt/stability_foldx-1.3.1.0.jar]

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.07

inputs:
  new_obj:
    type: File
    inputBinding:
      position: 0

outputs:
  foldx_batches:
    type: File[]
    outputBinding:
      glob: foldx_batch*
