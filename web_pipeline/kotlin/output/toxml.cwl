#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/openjdk-18/bin/java, -jar, /opt/loschmidt/outputModule-1.3.1.0.jar]
hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.13
inputs:
  new_obj:
    type: File
    inputBinding:
      position: 0
  commercial_user:
    type: string
    inputBinding:
      position: 1
  btc_multi_size:
    type: int
    inputBinding:
      position: 2
  btc_multi_double:
    type: double
    inputBinding:
      position: 3
  btc_mutations:
    type: string
    inputBinding:
      position: 4
  energy_multi_size:
    type: int
    inputBinding:
      position: 5
  energy_multi_double:
    type: double
    inputBinding:
      position: 6
  energy_mutations:
    type: string
    inputBinding:
      position: 7
  combined_multi_size:
    type: int
    inputBinding:
      position: 8
  combined_multi_double:
    type: double
    inputBinding:
      position: 9
  combined_mutations:
    type: string
    inputBinding:
      position: 10
  indexes:
    type: File
    inputBinding:
      position: 11
  old_obj:
    type: File
    inputBinding:
      position: 12

outputs:
  output_tex:
    type: File
    outputBinding:
      glob: output.tex

