#!/usr/bin/env cwl-tes

cwlVersion: v1.2
class: Workflow
requirements:
    MultipleInputFeatureRequirement: {}
    InlineJavascriptRequirement: {}
    SubworkflowFeatureRequirement: {}
inputs:
  sequences:
    type: File?
  msa:
    type: File?
  is_clustered:
    type: boolean
    default: false
outputs:
  stripped_sequences_out:
    type: File
    outputSource: clusteredSequences/stripped_sequences_out
  usearch_out_clusters:
    type: File
    outputSource: clusteredSequences/usearch_out_clusters
  usearch_out_nrfasta:
    type: File
    outputSource: clusteredSequences/usearch_out_nrfasta
  clustered_sequences_out:
    type: File
    outputSource: clusteredSequences/clustered_sequences_out
  pasta_out:
    type:
      type: array
      items: [File, Directory]
    outputSource: msaClustal/pasta_out
  treemer_list:
    type: File
    outputSource: msaClustal/treemer_list
  treemer_tree:
    type: File
    outputSource: msaClustal/treemer_tree
  fish_out:
    type: File
    outputSource: msaClustal/fish_out
  clustal_out:
    type: File
    outputSource: msaClustal/clustal_out
  iqtree_out:
    type:
      type: array
      items: [File, Directory]
    outputSource: iqtree/everything
  raxml_out:
    type:
      type: array
      items: [File, Directory]
    outputSource: raxml/everything
  mad_out:
    type:
      type: array
      items: [File, Directory]
    outputSource: mad/everything
  lazarus_out:
    type: File
    outputSource: lazarus/lazarus
  lazarus_out_tree:
    type: File
    outputSource: lazarus/lazarus_tree
  lazarus_out_nodes:
    type: File[]
    outputSource: lazarus/nodes
  lazarus_out_logs:
    type: File[]
    outputSource: lazarus/lazarus_logs
  lazarus_out_reformatted:
    type: File
    outputSource: lazarus/reformatted
  lazarus_out_paml:
    type: File[]
    outputSource: lazarus/pamlWorkspace
  combine_out:
    type: File
    outputSource: combine/combined_tree
  gaps_out_nodes:
    type: File[]
    outputSource: gaps/out_nodes
  ancestrals_out_nodes:
    type: File[]
    outputSource: parseancestrals/ancestrals


steps:
  clusteredSequences:
    run: clusteredSequence.cwl
    when: $(!inputs.is_clustered && inputs.sequences != null)
    in:
      sequences: sequences
      is_clustered: is_clustered
    out: [stripped_sequences_out, usearch_out_clusters, usearch_out_nrfasta, clustered_sequences_out]
  msaClustal:
    run: msaClustal.cwl
    when: $(inputs.msa === null)
    in:
      msa: msa
      sequencesClustered:
        id: sequencesClustered
        source: [clusteredSequences/clustered_sequences_out, sequences]
        pickValue: first_non_null
      sequences: sequences
    out: [pasta_out, treemer_list, treemer_tree, fish_out, clustal_out]
  iqtree:
    run: iqtree.cwl
    in:
      msa_clustal:
        id: msa_clustal
        source: [msaClustal/clustal_out, msa]
        pickValue: the_only_non_null
    out: [iqtree, everything]
  raxml:
    run: raxml.cwl
    in:
      msa_clustal:
        id: msa_clustal
        source: [msaClustal/clustal_out, msa]
        pickValue: the_only_non_null
      iqtree: iqtree/iqtree
    out: [besttree, everything]
  mad:
    run: mad.cwl
    in:
      besttree: raxml/besttree
    out: [besttree_rooted, everything]
  lazarus:
    run: lazarus.cwl
    in:
      msa_clustal:
        id: msa_clustal
        source: [msaClustal/clustal_out, msa]
        pickValue: the_only_non_null
      besttree_rooted: mad/besttree_rooted
    out: [lazarus, lazarus_tree, nodes, lazarus_logs, reformatted, pamlWorkspace]
  combine:
    run: combine.cwl
    in:
      tree: lazarus/lazarus_tree
    out: [combined_tree]
  gaps:
    run: gaps.cwl
    in:
      nodes: lazarus/nodes
      msa_clustal:
        id: msa_clustal
        source: [msaClustal/clustal_out, msa]
        pickValue: the_only_non_null
      combined_tree: combine/combined_tree
    out: [out_nodes]
  parseancestrals:
    run: ancestrals.cwl
    in:
      nodes: gaps/out_nodes
    out:
      [ancestrals]
