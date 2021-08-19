#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /usr/local/bin/web_scripts/mapindexes.py

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireweb:v0.05

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
      glob: indexes.out
  old_out:
    type: File
    outputBinding:
      glob: old.out
  new_out:
    type: File
    outputBinding:
      glob: new.out
