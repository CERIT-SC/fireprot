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
  clustered_sequences_out:
    type: File
    outputSource: createClustered/clustered_sequences
  fish_out:
    type: File
    outputSource: fishSequences/filtered_sequences
  combine_out:
    type: File
    outputSource: combine/combined_tree
  gaps_out:
    type: Directory
    outputSource: gaps/nodes
  lazarus_out:
    type: File
    outputSource: lazarus/lazarus
  lazarus_out_tree:
    type: File
    outputSource: lazarus/lazarus_tree
  clustal_out:
    type: File
    outputSource: clustal/msa_clustal
  iqtree_out:
    type: File
    outputSource: iqtree/iqtree
  mad_out_fixed:
    type: File
    outputSource: mad/besttree_fixed
  mad_out_rooted:
    type: File
    outputSource: mad/besttree_rooted
  pasta_out:
    type: File
    outputSource: pasta/pasta_tree
  raxml_out:
    type: File
    outputSource: raxml/besttree
  treemer_out:
    type: File
    outputSource: treemer/pasta_tree_trimmed
  treemer_out_list:
    type: File
    outputSource: treemer/pasta_tree_trimmed_list
  usearch_out_clusters:
    type: File
    outputSource: usearch/clusters
  usearch_out_nrfasta:
    type: File
    outputSource: usearch/nrfasta


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
    out: [pasta_tree]
  treemer:
    run: treemer.cwl
    in:
      pasta_tree: pasta/pasta_tree
    out: [pasta_tree_trimmed, pasta_tree_trimmed_list]
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
    out: [iqtree]
  raxml:
    run: raxml.cwl
    in:
      msa_clustal: clustal/msa_clustal
      iqtree: iqtree/iqtree
    out: [besttree]
  mad:
    run: mad.cwl
    in:
      besttree: raxml/besttree
    out: [besttree_rooted, besttree_fixed]
  lazarus:
    run: lazarus.cwl
    in:
      msa_clustal: clustal/msa_clustal
      besttree_rooted: mad/besttree_rooted
    out: [lazarus, lazarus_tree]
  combine:
    run: combine.cwl
    in:
      tree: lazarus/lazarus_tree
    out: [combined_tree]
  gaps:
    run: gaps.cwl
    in:
      msa_clustal: clustal/msa_clustal
      combined_tree: combine/combined_tree
    out: [nodes]
