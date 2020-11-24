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
      outDir: unify
      jobName: output
inputs:
  - id: input
    type: string
    doc: "Null"
outputs:
  - id: jobname
    type: File
    outputsource: unify/output
