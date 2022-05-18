#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/loschmidt:v0.15
inputs:
  pair_mutations_zip:
    type: File
  ddg_predictions_zip:
    type: File
  new_obj:
    type: File
  indexes:
    type: File
  btcmutations:
    type: File
  energymutations:
    type: File
  job_config:
    type: File
  pair_type:
    type: string

arguments:
  - prefix: -c
    valueFrom: |
        mkdir pairs; cd pairs; unzip $(inputs.pair_mutations_zip.path); cd ..;
        mkdir actmut; cd actmut; unzip $(inputs.ddg_predictions_zip); cd ..;
        cp $(inputs.new_obj.path) new_copy.obj;
        cp $(inputs.btcmutations.path) btcmutations_copy.obj;
        cp $(inputs.energymutations.path) energymutations_copy.obj;

        java -jar /opt/loschmidt/stability_pair_process-1.3.1.0.jar pairs actmut new_copy.obj $(inputs.indexes.path) btcmutations_copy.obj energymutations_copy.obj $(inputs.job_config.path) $(inputs.pair_type)

        rm -Rf pairs; rm -Rf actmut;

        zip combined_obj.zip combined_mutation*.obj
        zip combined_txt.zip combined_mutation*.txt
outputs:
  combined_mutations_obj_zip:
    type: File
    outputBinding:
      glob: combined_obj.zip
  combined_mutations_txt_zip:
    type: File
    outputBinding:
      glob: combined_txt.zip
  btcmutations:
    type: File
    outputBinding:
      glob: btcmutations_copy.obj
  energymutations:
    type: File
    outputBinding:
      glob: energymutations_copy.obj
  new_obj:
    type: File
    outputBinding:
      glob: new_copy.obj
