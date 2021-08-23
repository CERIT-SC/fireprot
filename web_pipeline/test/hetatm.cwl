#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /usr/local/bin/web_scripts/discardHetatms.py

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireweb:v0.09

inputs:
  pdb_repaired:
    type: File
    inputBinding:
      position: 0

outputs:
  pdb_hetatm:
    type: File
    outputBinding:
      glob: pdb_out
