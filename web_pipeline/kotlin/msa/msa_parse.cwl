#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /bin/bash

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.14

requirements:
  InlineJavascriptRequirement: {}

inputs:
  msa_objs:
    type: File[]
  old_obj:
    type: File
  factories:
    type: File[]

arguments:
  - prefix: -c
    valueFrom: |
      cp $(inputs.old_obj.path) old_msa.obj;
      for f in $(inputs.factories.map(function(factory){return factory.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/\\..*\$//"` ;
        MSASTR="msa_\${ID}.out"; MSAFILE="";
        for g in $(inputs.msa_objs.map(function(msa){return msa.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$MSASTR") ] ; then MSAFILE="\$g" ; fi
        done
        /opt/openjdk-18/bin/java -jar /opt/loschmidt/msaParser-1.3.1.0.jar "\$MSAFILE" old_msa.obj "\$f";
      done
outputs:
  old_msa_obj:
    type: File
    outputBinding:
      glob: old_msa.obj
