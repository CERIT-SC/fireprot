#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/usr/bin/java, -jar, /opt/loschmidt/btc-1.3.1.0.jar]

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.06

inputs:
  job_config:
    type: File
    inputBinding:
      position: 0
  old_obj:
    type: File
    inputBinding:
      position: 1
  new_obj:
    type: File
    inputBinding:
      position: 2
  indexes:
    type: File
    inputBinding:
      position: 3

outputs:
  btc_new:
    type: File
    outputBinding:
      glob: btc_new.obj
