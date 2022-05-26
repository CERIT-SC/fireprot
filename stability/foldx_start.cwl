#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/openjdk-18/bin/java, -jar, /opt/loschmidt/stability_foldx-1.3.1.0.jar]
requirements:
    InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/loschmidt:v0.19

inputs:
  new_obj:
    type: File
    inputBinding:
      position: 0
  job_config:
    type: File
    inputBinding:
      position: 1
  indexes:
    type: File
    inputBinding:
      position: 2

outputs:
  foldx_batches:
    type: File[]
    outputBinding:
      glob: ./f*.bin
  foldx_new_obj:
    type: File
    outputBinding:
      glob: stability_foldx_new.obj
  catalytic_distance:
    type: double
    outputBinding:
      glob: catalytic_distance
      loadContents: true
      outputEval: $(parseFloat(self[0].contents))
