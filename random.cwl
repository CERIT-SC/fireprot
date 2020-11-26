#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: cerit/fireprot
baseCommand: ["/bin/bash", "-c", "sleep 100; random.sh"]
requirements:
  EnvVarRequirement:
    envDef:
      outDir: ./
      jobName: output.$(inputs.jobname_in)
inputs: 
  - id: jobname_in
    type: string
outputs:
  - id: jobname_out
    type: File
    outputBinding:
      glob: output.$(inputs.jobname_in)
