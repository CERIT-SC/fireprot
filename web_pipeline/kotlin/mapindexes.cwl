#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /usr/bin/java -jar /opt/loschmidt/mapindexes-1.3.1.0.jar

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.01

inputs:
  pdb:
    type: File
    inputBinding:
      position: 0
  pdb_renumbered:
    type: File
    inputBinding:
      position: 1

outputs:
  indexes_out:
    type: File
    outputBinding:
      glob: indexes.obj
  old_out:
    type: File
    outputBinding:
      glob: old.pdb.obj
  new_out:
    type: File
    outputBinding:
      glob: new.pdb.obj
