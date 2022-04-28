#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.10
inputs:
  single_mutations_zip:
    type: File
  ddg_predictions_zip:
    type: File
  new_obj:
    type: File
  indexes:
    type: File
  mutations:
    type: File
  btcmutations:
    type: File
  energymutations:
    type: File
  job_config:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
        mkdir mutations; cd mutations; unzip $(inputs.single_mutations_zip.path); cd ..;
        mkdir actmut; cd actmut; unzip $(inputs.ddg_predictions_zip); cd ..;
        cp $(inputs.new_obj.path) new_copy.obj;
        cp $(inputs.mutations.path) mutations_copy.obj;
        cp $(inputs.btcmutations.path) btcmutations_copy.obj;
        cp $(inputs.energymutations.path) energymutations_copy.obj;

        // TODO make sure jar is correct
        java -jar /opt/loschmidt/stability_single_process-standalone-1.3.1.0.jar mutations actmut new_copy.obj $(inputs.indexes.path)  mutations_copy.obj btcmutations_copy.obj energymutations_copy.obj $(inputs.job_config.path)

        rm -Rf mutations; rm -Rf actmut;

        zip energy_obj.zip energy_mutation*.obj
        zip energy_txt.zip energy_mutation*.txt
        zip combined_obj.zip combined_mutation*.obj
        zip combined_txt.zip combined_mutation*.txt
outputs:
  energy_mutations_obj_zip:
    type: File
    outputBinding:
      glob: energy_obj.zip
  energy_mutations_txt_zip:
    type: File
    outputBinding:
      glob: energy_txt.zip
  combined_mutations_obj_zip:
    type: File
    outputBinding:
      glob: combined_obj.zip
  combined_mutations_txt_zip:
    type: File
    outputBinding:
      glob: combined_txt.zip
  mutations:
    type: File
    outputBinding:
      glob: mutations_copy.obj
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