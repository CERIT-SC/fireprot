#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
requirements:
    InlineJavascriptRequirement: {}
    MultipleInputFeatureRequirement: {}
inputs:
  new_obj:
    type: File
  commercial_user:
    type: string
    default: "false"
  btc_multi_size:
    type: int
  btc_multi_double:
    type: double
  btc_mutations:
    type: string
  energy_multi_size:
    type: int
  energy_multi_double:
    type: double
  energy_mutations:
    type: string
  combined_multi_size:
    type: int
  combined_multi_double:
    type: double
  combined_mutations:
    type: string
  indexes:
    type: File
  old_obj:
    type: File

outputs:
  output_tex:
    type: File
    outputSource: to_xml/output_tex
  output_pdf:
    type: File
    outputSource: to_pdf/output_pdf

steps:
  to_xml:
    run: output/toxml.cwl
    in:
      new_obj: new_obj
      commercial_user: commercial_user
      btc_multi_size: btc_multi_size
      btc_multi_double: btc_multi_double
      btc_mutations: btc_mutations
      energy_multi_size: energy_multi_size
      energy_multi_double: energy_multi_double
      energy_mutations: energy_mutations
      combined_multi_size: combined_multi_size
      combined_multi_double: combined_multi_double
      combined_mutations: combined_mutations
      indexes: indexes
      old_obj: old_obj
    out: [output_tex]
  to_pdf:
    run: output/topdf.cwl
    in:
      output_tex: to_xml/output_tex
    out: [output_pdf]
