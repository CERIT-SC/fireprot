#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/usr/bin/java, -jar, /opt/loschmidt/msaSetMinimized-1.3.1.0.jar]

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.10

requirements:
  InlineJavascriptRequirement: {}

inputs:
  old_msa_obj:
    type: File
    inputBinding:
      position: 0
  new_obj:
    type: File
    inputBinding:
      position: 1

outputs:
  new_msa_obj:
    type: File
    outputBinding:
      glob: new_msa.obj
