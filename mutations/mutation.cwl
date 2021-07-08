#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh
hints:
  DockerRequirement:
    dockerPull: cerit.io/rosetta:scriptedv0.7
  ResourceRequirement:
    coresMax: 4
    ramMin: 2048
inputs:
  input_dir_tar:
    type: File
  renumbered_pdb:
    type: File
  min_cst:
    type: File
  weights:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        mkdir input_mut ; cd input_mut ; tar xf $(inputs.input_dir_tar.path) ; if [ `find . -type d | wc -l` -gt 1 ] ; then mv */* . ; rmdir * ; fi ; cd .. ; python3 /usr/local/bin/mutate input_mut $(inputs.renumbered_pdb.path) $(inputs.min_cst.path) $(inputs.weights.path) && tar czf outputI.tar.gz iteration_I && tar czf outputII.tar.gz iteration_II
outputs:
  iterationI:
    type: File
    outputBinding:
      glob: outputI.tar.gz
  iterationII:
    type: File
    outputBinding:
      glob: outputII.tar.gz
