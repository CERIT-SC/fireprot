#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.12
inputs:
  batches:
    type: File[]
  averages:
    type: File[]
  individuals:
    type: File[]
  new:
    type: File
  job_config:
    type: File
  indexes:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
        cp $(inputs.new.path) new_copy.obj;
        for batch in $(inputs.batches.map(function(batch){return batch.path}).join(" ")) ; do
            ID=`echo "\$batch" | sed "s/.*_//" | sed "s/\\..*\$//"`
            for g in $(inputs.averages.map(function(average){return average.path}).join(" ")) ; do
              if [ ! -z \$(echo "\$g" | grep "_\$ID.fxout") ] ; then AVGFILE="\$g" ; fi
            done
            for g in $(inputs.individuals.map(function(individual){return individual.path}).join(" ")) ; do
              if [ ! -z \$(echo "\$g" | grep "_\$ID.txt") ] ; then INDIVIDUALFILE="\$g" ; fi
            done
            java -jar /opt/loschmidt/stability_foldx_process-1.3.1.0.jar "\$batch" "\$INDIVIDUALFILE" "\$AVGFILE" new_copy.obj mutations.obj btcmutations.obj energymutations.obj $(inputs.job_config.path) $(inputs.indexes.path) "\$ID"
        done
        zip btc_obj.zip btc_mutation*.obj
        zip btc_txt.zip btc_mutation*.txt
        zip combined_obj.zip combined_mutation*.obj
        zip combined_txt.zip combined_mutation*.txt
        zip single_obj.zip single_mutation*.obj
        zip single_txt.zip single_mutation*.txt
outputs:
  btc_mutations_obj_zip:
    type: File
    outputBinding:
      glob: btc_obj.zip
  btc_mutations_txt_zip:
    type: File
    outputBinding:
      glob: btc_txt.zip
  combined_mutations_obj_zip:
    type: File
    outputBinding:
      glob: combined_obj.zip
  combined_mutations_txt_zip:
    type: File
    outputBinding:
      glob: combined_txt.zip
  single_mutations_obj_zip:
    type: File
    outputBinding:
      glob: single_obj.zip
  single_mutations_txt_zip:
    type: File
    outputBinding:
      glob: single_txt.zip
  mutations:
    type: File
    outputBinding:
      glob: mutations.obj
  btcmutations:
    type: File
    outputBinding:
      glob: btcmutations.obj
  energymutations:
    type: File
    outputBinding:
      glob: energymutations.obj
  new_obj:
    type: File
    outputBinding:
      glob: new_copy.obj
