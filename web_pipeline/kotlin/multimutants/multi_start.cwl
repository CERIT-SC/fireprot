#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/openjdk-18/bin/java, -jar, /opt/loschmidt/multiMutants-1.3.1.0.jar]
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/loschmidt:v0.17
inputs:
  new_obj:
    type: File
    inputBinding:
      position: 0
  job_config:
    type: File
    inputBinding:
      position: 1

outputs:
  btc_multi_mut_txt:
    type: File
    outputBinding:
      glob: btc_multi_mutant.txt
  combined_multi_mut_txt:
    type: File
    outputBinding:
      glob: combined_multi_mutant.txt
  energy_multi_mut_txt:
    type: File
    outputBinding:
      glob: energy_multi_mutant.txt
  btc_mut_size:
    type: int
    outputBinding:
      glob: btc_mutations_size.txt
      loadContents: true
      outputEval: $(self[0].contents)
  combined_mut_size:
    type: int
    outputBinding:
      glob: combined_mutations_size.txt
      loadContents: true
      outputEval: $(self[0].contents)
  energy_mut_size:
    type: int
    outputBinding:
      glob: energy_mutations_size.txt
      loadContents: true
      outputEval: $(self[0].contents)
  multi_start_new_obj:
    type: File
    outputBinding:
      glob: new.obj
