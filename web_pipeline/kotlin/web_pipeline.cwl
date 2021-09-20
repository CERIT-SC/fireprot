#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
requirements:
    InlineJavascriptRequirement: {}
    SubworkflowFeatureRequirement: {}
inputs:
  pdb:
    type: File
  job_config:
    type: File
  #TODO config
outputs:
  preparation_foldx_repair:
    type: File
    outputSource: preparation/foldx_repair
  preparation_foldx_fxout:
    type: File
    outputSource: preparation/foldx_fxout
  preparation_hetatm_pdb:
    type: File
    outputSource: preparation/hetatm_pdb
  preparation_renumbered:
    type: File
    outputSource: preparation/renumbered
  preparation_minimize_rossetta:
    type: File
    outputSource: preparation/minimize_rossetta
  preparation_minimize_renumbered:
    type: File
    outputSource: preparation/minimize_renumbered
  preparation_filter_min_cst:
    type: File
    outputSource: preparation/filter_min_cst
  preparation_map_indexes:
    type: File
    outputSource: preparation/map_indexes
  preparation_map_old:
    type: File
    outputSource: preparation/map_old
  preparation_map_new:
    type: File
    outputSource: preparation/map_new
  msa_msa_queries:
    type: File[]
    outputSource: msa/msa_queries
  msa_msa_factories:
    type: File[]
    outputSource: msa/msa_factories
  msa_msa_conf:
    type: File
    outputSource: msa/msa_conf
  msa_blast_xmls:
    type: File[]
    outputSource: msa/blast_xmls
  msa_blast_ids:
    type: File[]
    outputSource: msa/blast_ids_ids
  msa_blast_id_sequences:
    type: File[]
    outputSource: msa/blast_id_sequences
  msa_blast_sequences:
    type: File[]
    outputSource: msa/blast_sequences_sequences
  msa_blast_full_sequences:
    type: File[]
    outputSource: msa/blast_full_sequences
  msa_blast_saved_sequences:
    type: File[]
    outputSource: msa/blast_saved_sequences
  msa_usearch1_objs:
    type: File[]
    outputSource: msa/usearch1_objs
  msa_filter_identity_sequences:
    type: File[]
    outputSource: msa/filter_identity_sequences
  msa_filter_identity_sequences_saved:
    type: File[]
    outputSource: msa/filter_identity_sequences_saved
  msa_usearch2_objs:
    type: File[]
    outputSource: msa/usearch2_objs
  msa_filter_clustering_sequences:
    type: File[]
    outputSource: msa/filter_clustering_sequences
  msa_filter_clustering_sequences_saved:
    type: File[]
    outputSource: msa/filter_clustering_sequences_saved
  msa_filter_coverage_seqeunces:
    type: File[]
    outputSource: msa/filter_coverage_seqeunces
  msa_filter_coverage_seqeunces_saved:
    type: File[]
    outputSource: msa/filter_coverage_seqeunces_saved
  msa_msa_objs:
    type: File[]
    outputSource: msa/msa_objs
  msa_old_msa_obj:
    type: File
    outputSource: msa/old_msa_obj
  msa_new_msa_obj:
    type: File
    outputSource: msa/new_msa_obj

steps:
  preparation:
    run: preparation.cwl
    in:
      pdb: pdb
    out: [foldx_repair, foldx_fxout, hetatm_pdb, renumbered, minimize_rossetta, minimize_renumbered, filter_min_cst, map_indexes, map_old, map_new]
  msa:
    run: msa.cwl
    in:
      job_config: job_config
      old_obj: preparation/map_old
      new_obj: preparation/map_new
    out: [msa_queries, msa_factories, msa_conf, blast_xmls, blast_ids_ids, blast_id_sequences, blast_sequences_sequences, blast_full_sequences, blast_saved_sequences, usearch1_objs, filter_identity_sequences, filter_identity_sequences_saved, usearch2_objs, filter_clustering_sequences, filter_clustering_sequences_saved, filter_coverage_seqeunces, filter_coverage_seqeunces_saved, msa_objs, old_msa_obj, new_msa_obj]
  conservation_analysis:
    run: conservation_analysis.cwl
    in:
      old_obj: msa/old_msa_obj
      new_obj: msa/new_msa_obj
      indexes: preparation/map_indexes
    out: [conservation_new]
  btc:
    run: btc.cwl
    in:
      job_config: job_config
      old_obj: msa/old_msa_obj
      new_obj: conservation_analysis/conservation_new
      indexes: preparation/map_indexes
    out: [btc_new]
  cmanalysis:
    run: cmanalysis.cwl
    in:
      old_obj: msa/old_msa_obj
      new_obj: btc/btc_new
      job_config: job_config
      indexes: preparation/map_indexes
    out: [fodors, freecontacts, amic_round1_outputs, amic_round2_outputs, amic_round3_outputs, amic_parser_old, freecontacts_dca, csvs, cma_old, cma_new]
