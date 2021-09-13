#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /usr/bin/java -jar /opt/loschmidt/hetatm-1.3.1.0.jar

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.01

inputs:
  pdb_repaired:
    type: File
    inputBinding:
      position: 0

outputs:
  pdb_hetatm:
    type: File
    outputBinding:
      glob: hetatm.pdb
