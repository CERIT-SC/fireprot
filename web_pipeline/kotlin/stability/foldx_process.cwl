#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: bash
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/loschmidt:v0.15
inputs:
  batches:
    type: File[]
  averages_zip:
    type: File
  individuals_zip:
    type: File
  new:
    type: File
  job_config:
    type: File
  indexes:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
        touch emptyfile
        zip btc_obj.zip emptyfile
        zip btc_txt.zip emptyfile
        zip combined_obj.zip emptyfile
        zip combined_txt.zip emptyfile
        zip single_obj.zip emptyfile
        zip single_txt.zip emptyfile
        zip -d btc_obj.zip emptyfile
        zip -d btc_txt.zip emptyfile
        zip -d combined_obj.zip emptyfile
        zip -d combined_txt.zip emptyfile
        zip -d single_obj.zip emptyfile
        zip -d single_txt.zip emptyfile
        rm emptyfile
        cp $(inputs.new.path) new_copy.obj;
        unzip $(inputs.averages_zip.path)
        unzip $(inputs.individuals_zip.path)
        for f in *fxout ; do if [ ! -f "\$f" ] ; then continue ; fi ; ID=\$(echo "\$f" | sed 's/.*_//' | sed 's/\\..*//') ; mkdir "ID_\${ID}"; mv *_\${ID}.* "ID_\${ID}" ; done;
        for batch in $(inputs.batches.map(function(batch){return batch.path}).join(" ")) ; do
            ID=`echo "\$batch" | sed "s/.*_//" | sed "s/\\..*\$//"`
            java -jar /opt/loschmidt/stability_foldx_process-1.3.1.0.jar "\$batch" "ID_\$ID" new_copy.obj mutations.obj btcmutations.obj energymutations.obj $(inputs.job_config.path) $(inputs.indexes.path) "\$ID"
        done
        zip btc_obj.zip btc_mutation*.obj
        zip btc_txt.zip btc_mutation*.txt
        zip combined_obj.zip combined_mutation*.obj
        zip combined_txt.zip combined_mutation*.txt
        zip single_obj.zip single_mutation*.obj
        zip single_txt.zip single_mutation*.txt
        echo "DONE"
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
