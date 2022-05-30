#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/openjdk-18/bin/java, -jar, /opt/loschmidt/hetatm-1.3.1.0.jar]

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/loschmidt:v0.22

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
