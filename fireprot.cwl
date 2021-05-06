#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
inputs:
  strippedSequences:
    type: File
  sequencesClustered:
    type: File
  filteredSequences:
    type: File
outputs:
  file_out:
    type: File
    outputSource: lazarus/lazarus

steps:
  usearch:
    run: usearch.cwl
    in:
      strippedSequences: strippedSequences
    out: [clusters, nrfasta]
  pasta:
    run: pasta.cwl
    in:
      sequencesClustered: sequencesClustered
    out: [pasta_tree]
  treemer:
    run: treemer.cwl
    in:
      pasta_tree: pasta/pasta_tree
    out: [pasta_tree_trimmed]
  clustal:
    run: clustal.cwl
    in:
      filtered_sequences: filteredSequences
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
    out: [lazarus]
