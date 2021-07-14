#!/usr/bin/env cwl-tes

cwlVersion: v1.2
class: Workflow
requirements:
    MultipleInputFeatureRequirement: {}
    InlineJavascriptRequirement: {}
inputs:
  msa:
    type: File?
  sequencesClustered:
    type: File
  sequences:
    type: File
outputs:
  pasta_out:
    type:
      type: array
      items: [File, Directory]
    outputSource: pasta/everything
  treemer_list:
    type: File
    outputSource: treemer/pasta_tree_trimmed_list
  treemer_tree:
    type: File
    outputSource: treemer/pasta_tree_trimmed_tree
  fish_out:
    type: File
    outputSource: fishSequences/filtered_sequences
  clustal_out:
    type: File
    outputSource: clustal/msa_clustal

steps:
  pasta:
    run: pasta.cwl
    in:
      sequencesClustered: sequencesClustered
    out: [pasta_tree, everything]
  treemer:
    run: treemer.cwl
    in:
      pasta_tree: pasta/pasta_tree
    out: [pasta_tree_trimmed_list, pasta_tree_trimmed_tree]
  fishSequences:
    run: fishSequences.cwl
    in:
      pasta_trimmed: treemer/pasta_tree_trimmed_list
      sequences: sequences
    out: [filtered_sequences]
  clustal:
    run: clustal.cwl
    in:
      filtered_sequences: fishSequences/filtered_sequences
    out: [msa_clustal]
