#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh

hints:
  DockerRequirement:
    dockerPull: cerit.io/blast:2.8.1-s3

inputs:
  bucket:
    type: string

arguments:
  - prefix: -c
    valueFrom: |
        cp /root/.s3cfg \${HOME}/.s3cfg && s3cmd sync $(inputs.bucket) outputbucket && ls outputbucket
outputs:
  standard:
    type: stdout
