#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/loschmidt:v0.19

inputs:
  old_obj:
    type: File
  amic_outputs:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      cp $(inputs.old_obj.path) old.obj
      for f in $(inputs.amic_outputs.map(function(output){return output.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/\\..*\$//"` ;
        /opt/openjdk-18/bin/java -jar /opt/loschmidt/amicParser-1.3.1.0.jar old.obj "\$f" "\${ID}" ;
      done

outputs:
  amic_old:
    type: File
    outputBinding:
      glob: old.obj
