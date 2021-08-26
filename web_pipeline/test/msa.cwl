#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: /usr/local/bin/web_scripts/msa.py

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: cerit.io/fireweb:v0.11

inputs:
  old_out:
    type: File
    inputBinding:
      position: 0

outputs:
  queries_fasta:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*.fasta
  msa_factories:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*.factory
  evalue:
    type: string
    outputBinding:
      glob: evalue.txt
      loadContents: true
      outputEval: $(self[0].contents)
  minidentity:
    type: double
    outputBinding:
      glob: minidentity.txt
      loadContents: true
      outputEval: $(self[0].contents)
  minidentityhundredth:
    type: double
    outputBinding:
      glob: minidentityhundredth.txt
      loadContents: true
      outputEval: $(self[0].contents)
  maxidentity:
    type: double
    outputBinding:
      glob: maxidentity.txt
      loadContents: true
      outputEval: $(self[0].contents)
