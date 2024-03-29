#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/alpine-zip:v0.1
inputs:
  zips:
    type: File[]
arguments:
  - prefix: -c
    valueFrom: |
        touch emptyfile
        zip output.zip emptyfile
        zip -d output.zip emptyfile
        rm emptyfile
        mkdir zipped ; cd zipped;
        for zip in $(inputs.zips.map(function(zip){return zip.path}).join(" ")) ; do
            unzip "$zip"
        done
        zip ../output.zip *
        cd ..
        rm -Rf zipped
outputs:
  output_zip:
    type: File
    outputBinding:
      glob: output.zip
