#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
inputs:
  pdb:
    type: File
  job_config:
    type: File
  sequences_prefix:
    type: string
    default: "blast_seqs"
  sequences_identity_filter_prefix:
    type: string
    default: "identity_filter_seqs"
  sequences_clustering_filter_prefix:
    type: string
    default: "clustering_filter_seqs"
  sequences_coverage_filter_prefix:
    type: string
    default: "coverage_filter_seqs"
  #TODO config
outputs:
  pdb_repaired:
    type: File
    outputSource: foldx/input_repair
  pdb_fxout:
    type: File
    outputSource: foldx/input_repair_fxout
  pdb_hetatm:
    type: File
    outputSource: hetatm/pdb_hetatm
  pdb_renumbered:
    type: File
    outputSource: renumber/input_renumbered
  pdb_minimized:
    type: File
    outputSource: minimize/input_renumbered_out
  rossetta_out_minimized:
    type: File
    outputSource: minimize/rossetta_out
  min_cst:
    type: File
    outputSource: filter/min_cst
  indexes_out:
    type: File
    outputSource: map/indexes_out
  old_out:
    type: File
    outputSource: map/old_out
  new_out:
    type: File
    outputSource: map/new_out
  queries_fasta:
    type:
      type: array
      items: [File, Directory]
    outputSource: msa/queries_fasta
  msa_factories:
    type:
      type: array
      items: [File, Directory]
    outputSource: msa/msa_factories
  msa_conf:
    type: File
    outputSource: msa/msa_conf
  blast_xmls:
    type:
      type: array
      items: [File, Directory]
    outputSource: blast/blast_xmls
  blast_extract:
    type:
      type: array
      items: [File, Directory]
    outputSource: blast_extract/full_seqs
  blast_ids:
    type:
      type: array
      items: [File, Directory]
    outputSource: blast_ids/blast_ids
  blast_ids_sequences:
    type:
      type: array
      items: [File, Directory]
    outputSource: blast_ids/sequences
  blast_sequences:
    type:
      type: array
      items: [File, Directory]
    outputSource: blast_sequences/blast_sequences
  usearch1_outs:
    type:
      type: array
      items: [File, Directory]
    outputSource: usearch1/usearch1_outs
  usearch2_outs:
    type:
      type: array
      items: [File, Directory]
    outputSource: usearch2/usearch2_outs
  sequences_filtered_identity:
    type:
      type: array
      items: [File, Directory]
    outputSource: filteridentity/sequences
  clustalo:
    type:
      type: array
      items: [File, Directory]
    outputSource: clustalo/clustalo_outs
  filterclustering:
    type:
      type: array
      items: [File, Directory]
    outputSource: filterclustering/sequences
  filtercoverage:
    type:
      type: array
      items: [File, Directory]
    outputSource: filtercoverage/sequences
  blast_seqs:
    type:
      type: array
      items: [File, Directory]
    outputSource: save_sequences/seqs
  identity_filter:
    type:
      type: array
      items: [File, Directory]
    outputSource: save_sequences_identity_filtered/seqs
  identity_clustered:
    type:
      type: array
      items: [File, Directory]
    outputSource: save_sequences_clustering_filtered/seqs
  identity_coverage:
    type:
      type: array
      items: [File, Directory]
    outputSource: save_sequences_coverage_filtered/seqs

steps:
  foldx:
    run: foldx.cwl
    in:
      pdb: pdb
    out: [input_repair, input_repair_fxout]
  hetatm:
    run: hetatm.cwl
    in:
      pdb_repaired: foldx/input_repair
    out: [pdb_hetatm]
  renumber:
    run: renumber.cwl
    in:
      pdb_hetatm: hetatm/pdb_hetatm
    out: [input_renumbered]
  minimize:
    run: minimize.cwl
    in:
      input_renumbered: renumber/input_renumbered
    out: [rossetta_out, input_renumbered_out]
  filter:
    run: filter.cwl
    in:
      rossetta_out: minimize/rossetta_out
    out: [min_cst]
  map:
    run: mapindexes.cwl
    in:
      pdb: pdb
      pdb_renumbered: minimize/input_renumbered_out
    out: [indexes_out, old_out, new_out]
  msa:
    run: msa.cwl
    in:
      job_config: job_config
      old_out: map/old_out
    out: [queries_fasta, msa_factories, msa_conf, evalue, minsize, maxsize, minidentity, minidentityhundredth, maxidentity, clusteringthreshold]
  blast:
    run: blast.cwl
    in:
      evalue: msa/evalue
      queries_fasta: msa/queries_fasta
    out: [blast_xmls]
  blast_ids:
    run: blast_ids.cwl
    in:
      msa_factories: msa/msa_factories
      blast_xmls: blast/blast_xmls
    out: [blast_ids, sequences]
  blast_sequences:
    run: blast_sequences.cwl
    in:
      blast_ids: blast_ids/blast_ids
    out: [blast_sequences]
  blast_extract:
    run: blast_extract.cwl
    in:
      blast_seqs: blast_sequences/blast_sequences
      sequences: blast_ids/sequences
      factories: msa/msa_factories
    out: [full_seqs]
  save_sequences:
    run: save_sequences.cwl
    in:
      factories: msa/msa_factories
      sequences: blast_ids/sequences
      prefix: sequences_prefix
    out: [seqs]
  usearch1:
    run: usearch1.cwl
    in:
      queries_fasta: msa/queries_fasta
      full_seqs: blast_extract/full_seqs
      min_identity: msa/minidentityhundredth
    out: [usearch1_outs]
  filteridentity:
    run: filteridentity.cwl
    in:
      sequences: blast_ids/sequences
      usearch1s: usearch1/usearch1_outs
      factories: msa/msa_factories
    out: [sequences]
  save_sequences_identity_filtered:
    run: save_sequences.cwl
    in:
      factories: msa/msa_factories
      sequences: filteridentity/sequences
      prefix: sequences_identity_filter_prefix
    out: [seqs]
  usearch2:
    run: usearch2.cwl
    in:
      filtered_seqs: save_sequences_identity_filtered/seqs
      clusteringthreshold: msa/clusteringthreshold
    out: [usearch2_outs]
  filterclustering:
    run: filterclustering.cwl
    in:
      filtered_seqs_objects: filteridentity/sequences
      usearch2s: usearch1/usearch1_outs
      factories: msa/msa_factories
    out: [sequences]
  save_sequences_clustering_filtered:
    run: save_sequences.cwl
    in:
      factories: msa/msa_factories
      sequences: filterclustering/sequences
      prefix: sequences_clustering_filter_prefix
    out: [seqs]
  filtercoverage:
    run: filtercoverage.cwl
    in:
      filtered_seqs_objects: filterclustering/sequences
      factories: msa/msa_factories
    out: [sequences]
  save_sequences_coverage_filtered:
    run: save_sequences.cwl
    in:
      factories: msa/msa_factories
      sequences: filtercoverage/sequences
      prefix: sequences_coverage_filter_prefix
    out: [seqs]
  clustalo:
    run: clustalo.cwl
    in:
      coverage_fasta: save_sequences_coverage_filtered/seqs
    out: [clustalo_outs]
