#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/loschmidt:v0.14
inputs:
  combined_mutations_zip:
    type: File
  ddg_predictions_zip:
    type: File
  new_obj:
    type: File
  indexes:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
        mkdir combined; cd combined; unzip $(inputs.combined_mutations_zip.path); cd ..;
        mkdir actmut; cd actmut; unzip $(inputs.ddg_predictions_zip); cd ..;
        cp $(inputs.new_obj.path) new_copy.obj;

        java -jar /opt/loschmidt/stability_combinedpairs_process-1.3.1.0.jar combined actmut new_copy.obj $(inputs.indexes.path)

        rm -Rf combined; rm -Rf actmut;
outputs:
  new_obj:
    type: File
    outputBinding:
      glob: new_copy.obj
