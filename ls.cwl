#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: cerit/fireprot
baseCommand: ls.sh
requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.input)
        entryname: path.txt
  EnvVarRequirement:
    envDef:
      outDir: ./
inputs:
  - id: input
    type: File
    inputBinding:
      position: 1
outputs:
  - id: stdout
    type: File
    outputBinding:
      glob: stdout
  - id: stderr
    type: File
    outputBinding:
      glob: stderr
