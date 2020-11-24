#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: cerit/fireprot
baseCommand: random.sh
requirements:
  EnvVarRequirement:
    envDef:
      outDir: ./
      jobName: output
inputs: []
outputs:
  - id: jobname
    type: File
    outputBinding:
      glob: output
