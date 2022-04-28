#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: bash
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.10
inputs:
  new_obj:
    type: File
  job_config:
    type: File
  type:
    type: string
  ddg_predictions:
    type: File
  size:
    type: int
  stdout:
    type: File
  minimized_pdb:
    type: File
  mutations_zip:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
        cp $(inputs.new_obj.path) new.obj && mkdir mutations && cd mutations && unzip $(inputs.mutations_zip.path) && cd .. && /usr/bin/java -jar /opt/loschmidt/multiMutants_process-1.3.1.0.jar new.obj $(inputs.job_config.path) $(inputs.type) $(inputs.ddg_predictions.path) $(inputs.size) $(inputs.stdout.path) $(inputs.minimized_pdb.path) mutations

outputs:
  new_obj:
    type: File
    outputBinding:
      glob: new.obj
  best_structure:
    type: string
    outputBinding:
      glob: ./*best_structure.txt
      loadContents: true
      outputEval: $(self[0].contents)
  pdb_update:
    type: File
    outputBinding:
      glob: ./*PDBUpdate.pdb
  multi_double:
    type: double
    outputBinding:
      glob: ./multi*.txt
      loadContents: true
      outputEval: $(self[0].contents)
  mutations_string:
    type: string
    outputBinding:
      glob: ./mutations*.txt
      loadContents: true
      outputEval: $(self[0].contents)

