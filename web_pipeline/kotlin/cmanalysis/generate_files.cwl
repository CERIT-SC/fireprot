#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/usr/bin/java, -jar, /opt/loschmidt/cmanalysis-1.3.1.0.jar]

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.07

inputs:
  old_obj:
    type: File
    inputBinding:
      position: 0
  new_obj:
    type: File
    inputBinding:
      position: 1

outputs:
  fodors:
    type: File[]
    outputBinding:
      glob: ./*.fodor
  freecontacts:
    type: File[]
    outputBinding:
      glob: ./*.freecontact
