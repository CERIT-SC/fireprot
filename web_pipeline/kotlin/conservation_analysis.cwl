#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/usr/bin/java, -jar, /opt/loschmidt/conservationAnalysis-1.3.1.0.jar]

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.04

inputs:
  old_obj:
    type: File
    inputBinding:
      position: 0
  new_obj:
    type: File
    inputBinding:
      position: 1
  indexes:
    type: File
    inputBinding:
      position: 2

outputs:
  conservation_new:
    type: File
    outputBinding:
      glob: conservation_new.obj
