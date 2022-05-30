#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/loschmidt:v0.22
inputs:
  new_obj:
    type: File
  job_config:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
        cp $(inputs.new_obj.path) new_copy.obj
        /opt/openjdk-18/bin/java -jar /opt/loschmidt/multiMutants-1.3.1.0.jar new_copy.obj $(inputs.job_config.path)

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
      outputEval: $(parseInt(self[0].contents))
  combined_mut_size:
    type: int
    outputBinding:
      glob: combined_mutations_size.txt
      loadContents: true
      outputEval: $(parseInt(self[0].contents))
  energy_mut_size:
    type: int
    outputBinding:
      glob: energy_mutations_size.txt
      loadContents: true
      outputEval: $(parseInt(self[0].contents))
  multi_start_new_obj:
    type: File
    outputBinding:
      glob: new_copy.obj
