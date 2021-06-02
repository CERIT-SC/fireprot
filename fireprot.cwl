#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
inputs:
  sequences:
    type: File
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
  pasta_out:
    type:
      type: array
      items: [File, Directory]
    outputSource: pasta/everything
  treemer_out:
    type:
      type: array
      items: [File, Directory]
    outputSource: treemer/everything
  fish_out:
    type: File
    outputSource: fishSequences/filtered_sequences
  clustal_out:
    type: File
    outputSource: clustal/msa_clustal
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
  pasta:
    run: pasta.cwl
    in:
      sequencesClustered: createClustered/clustered_sequences
    out: [pasta_tree, everything]
  treemer:
    run: treemer.cwl
    in:
      pasta_tree: pasta/pasta_tree
    out: [pasta_tree_trimmed_list, everything]
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
  iqtree:
    run: iqtree.cwl
    in:
      msa_clustal: clustal/msa_clustal
    out: [iqtree, everything]
  raxml:
    run: raxml.cwl
    in:
      msa_clustal: clustal/msa_clustal
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
      msa_clustal: clustal/msa_clustal
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
      msa_clustal: clustal/msa_clustal
      combined_tree: combine/combined_tree
    out: [out_nodes]
  parseancestrals:
    run: ancestrals.cwl
    in:
      nodes: gaps/out_nodes
    out:
      [ancestrals]
