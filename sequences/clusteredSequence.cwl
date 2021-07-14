#!/usr/bin/env cwl-tes

cwlVersion: v1.2
class: Workflow
requirements:
    MultipleInputFeatureRequirement: {}
    InlineJavascriptRequirement: {}
inputs:
  sequences:
    type: File
  is_clustered:
    type: boolean
    default: false
outputs:
  stripped_sequences_out:
    type: File
    outputSource: filterByLength/stripped_sequences
  usearch_out_clusters:
    type: File
    outputSource: usearch/clusters
  usearch_out_nrfasta:
    type: File
    outputSource: usearch/nrfasta
  clustered_sequences_out:
    type: File
    outputSource: createClustered/clustered_sequences

steps:
  filterByLength:
    run: filterByLength.cwl
    in:
      sequences: sequences
    out: [stripped_sequences]
  usearch:
    run: usearch.cwl
    in:
      strippedSequences: filterByLength/stripped_sequences
    out: [clusters, nrfasta]
  createClustered:
    run: createClustered.cwl
    in:
      clusters: usearch/clusters
      stripped_sequences: filterByLength/stripped_sequences
    out: [clustered_sequences]
