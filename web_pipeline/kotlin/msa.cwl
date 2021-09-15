#!/usr/bin/env cwl-tes

cwlVersion: v1.1
class: Workflow
requirements:
    InlineJavascriptRequirement: {}
inputs:
  job_config:
    type: File
  old_obj:
    type: File
  new_obj:
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
outputs:
  msa_queries:
    type: File[]
    outputSource: msa/queries_fasta
  msa_factories:
    type: File[]
    outputSource: msa/msa_factories
  msa_conf:
    type: File
    outputSource: msa/msa_conf
  blast_xmls:
    type: File[]
    outputSource: blast/blast_xmls
  blast_ids_ids:
    type: File[]
    outputSource: blast_ids/blast_ids
  blast_id_sequences:
    type: File[]
    outputSource: blast_ids/sequences
  blast_sequences_sequences:
    type: File[]
    outputSource: blast_sequences/blast_sequences
  blast_full_sequences:
    type: File[]
    outputSource: blast_extract/full_seqs
  blast_saved_sequences:
    type: File[]
    outputSource: save_sequences/seqs
  usearch1_objs:
    type: File[]
    outputSource: usearch1/usearch1_outs
  filter_identity_sequences:
    type: File[]
    outputSource: filter_identity/sequences
  filter_identity_sequences_saved:
    type: File[]
    outputSource: save_sequences_identity_filtered/seqs
  usearch2_objs:
    type: File[]
    outputSource: usearch2/usearch2_outs
  filter_clustering_sequences:
    type: File[]
    outputSource: filter_clustering/sequences
  filter_clustering_sequences_saved:
    type: File[]
    outputSource: save_sequences_clustering_filtered/seqs
  filter_coverage_seqeunces:
    type: File[]
    outputSource: filter_coverage/sequences
  filter_coverage_seqeunces_saved:
    type: File[]
    outputSource: save_sequences_coverage_filtered/seqs
  msa_objs:
    type: File[]
    outputSource: clustalo/clustalo_outs
  old_msa_obj:
    type: File
    outputSource: msa_parse/old_msa_obj
  new_msa_obj:
    type: File
    outputSource: msa_set_minimized/new_msa_obj

steps:
  msa:
    run: msa/msa.cwl
    in:
      job_config: job_config
      old_obj: old_obj
    out: [queries_fasta, msa_factories, msa_conf, evalue, minsize, maxsize, minidentity, minidentityhundredth, maxidentity, clusteringthreshold]
  blast:
    run: msa/blast.cwl
    in:
      evalue: msa/evalue
      queries_fasta: msa/queries_fasta
    out: [blast_xmls]
  blast_ids:
    run: msa/blast_ids.cwl
    in:
      msa_factories: msa/msa_factories
      blast_xmls: blast/blast_xmls
    out: [blast_ids, sequences]
  blast_sequences:
    run: msa/blast_sequences.cwl
    in:
      blast_ids: blast_ids/blast_ids
    out: [blast_sequences]
  blast_extract:
    run: msa/blast_extract.cwl
    in:
      blast_seqs: blast_sequences/blast_sequences
      sequences: blast_ids/sequences
      factories: msa/msa_factories
    out: [full_seqs]
  save_sequences:
    run: msa/save_sequences.cwl
    in:
      factories: msa/msa_factories
      sequences: blast_ids/sequences
      prefix: sequences_prefix
    out: [seqs]
  usearch1:
    run: msa/usearch1.cwl
    in:
      queries_fasta: msa/queries_fasta
      full_seqs: blast_extract/full_seqs
      min_identity: msa/minidentityhundredth
    out: [usearch1_outs]
  filter_identity:
    run: msa/filter_identity.cwl
    in:
      sequences_in: blast_ids/sequences
      usearch1s: usearch1/usearch1_outs
      factories: msa/msa_factories
    out: [sequences]
  save_sequences_identity_filtered:
    run: msa/save_sequences.cwl
    in:
      factories: msa/msa_factories
      sequences: filter_identity/sequences
      prefix: sequences_identity_filter_prefix
    out: [seqs]
  usearch2:
    run: msa/usearch2.cwl
    in:
      filtered_seqs: save_sequences_identity_filtered/seqs
      clusteringthreshold: msa/clusteringthreshold
    out: [usearch2_outs]
  filter_clustering:
    run: msa/filter_clustering.cwl
    in:
      filtered_seqs_objects: filter_identity/sequences
      usearch2s: usearch2/usearch2_outs
      factories: msa/msa_factories
    out: [sequences]
  save_sequences_clustering_filtered:
    run: msa/save_sequences.cwl
    in:
      factories: msa/msa_factories
      sequences: filter_clustering/sequences
      prefix: sequences_clustering_filter_prefix
    out: [seqs]
  filter_coverage:
    run: msa/filter_coverage.cwl
    in:
      filtered_seqs_objects: filter_clustering/sequences
      factories: msa/msa_factories
    out: [sequences]
  save_sequences_coverage_filtered:
    run: msa/save_sequences.cwl
    in:
      factories: msa/msa_factories
      sequences: filter_coverage/sequences
      prefix: sequences_coverage_filter_prefix
    out: [seqs]
  clustalo:
    run: msa/clustalo.cwl
    in:
      coverage_fasta: save_sequences_coverage_filtered/seqs
    out: [clustalo_outs]
  msa_parse:
    run: msa/msa_parse.cwl
    in:
      msa_objs: clustalo/clustalo_outs
      old_obj: old_obj
      factories: msa/msa_factories
    out: [old_msa_obj]
  msa_set_minimized:
    run: msa/msa_set_minimized.cwl
    in:
      old_msa_obj: msa_parse/old_msa_obj
      new_obj: new_obj
    out: [new_msa_obj]
