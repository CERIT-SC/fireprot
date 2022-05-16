#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/openjdk-18/bin/java, -jar, /opt/loschmidt/cmanalysisEnd-1.3.1.0.jar]

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.13

inputs:
  old_obj:
    type: File
    inputBinding:
      position: 0
  new_obj:
    type: File
    inputBinding:
      position: 1
  job_config:
    type: File
    inputBinding:
      position: 2
  indexes:
    type: File
    inputBinding:
      position: 3

outputs:
  cmanalysis_old:
    type: File
    outputBinding:
      glob: cmanalysis_old.obj
  cmanalysis_new:
    type: File
    outputBinding:
      glob: cmanalysis_new.obj
  csvs:
    type: File[]
    outputBinding:
      glob: ./*.csv
