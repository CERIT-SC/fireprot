#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/usr/bin/java, -jar, /opt/loschmidt/msa-1.3.1.0.jar]

hints:
  DockerRequirement:
    dockerPull: cerit.io/loschmidt:v0.02

requirements:
  InlineJavascriptRequirement: {}

inputs:
  job_config:
    type: File
    inputBinding:
      position: 0
  old_out:
    type: File
    inputBinding:
      position: 1

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
      glob: ./*.obj
  msa_conf:
    type: File
    outputBinding:
      glob: msa.obj.conf
  evalue:
    type: string
    outputBinding:
      glob: evalue.txt
      loadContents: true
      outputEval: $(self[0].contents)
  minsize:
    type: int
    outputBinding:
      glob: minsize.txt
      loadContents: true
      outputEval: $(self[0].contents)
  maxsize:
    type: int
    outputBinding:
      glob: maxsize.txt
      loadContents: true
      outputEval: $(self[0].contents)
  minidentity:
    type: double
    outputBinding:
      glob: minid.txt
      loadContents: true
      outputEval: $(self[0].contents)
  minidentityhundredth:
    type: double
    outputBinding:
      glob: minid.txt
      loadContents: true
      outputEval: $(parseFloat(self[0].contents)/100.0)
  maxidentity:
    type: double
    outputBinding:
      glob: maxid.txt
      loadContents: true
      outputEval: $(self[0].contents)
  clusteringthreshold:
    type: double
    outputBinding:
      glob: clustering.txt
      loadContents: true
      outputEval: $(self[0].contents)
