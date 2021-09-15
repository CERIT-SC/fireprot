#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
requirements:
    MultipleInputFeatureRequirement: {}
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
    outputSource: msa/blast_ids
  msa_blast_id_sequences:
    type: File[]
    outputSource: msa/blast_id_sequences
  msa_blast_sequences:
    type: File[]
    outputSource: msa/blast_sequences
  msa_blast_full_sequences:
    type: File[]
    outputSource: msa/blast_full_sequences
  msa_blast_saved_sequences:
    type: File[]
    outputSource: msa/blast_saved_sequences
  msa_usearch1_objs:
    type: File[]
    outputSource: msa/usearch1_objs
  msa_filteridentity_sequences:
    type: File[]
    outputSource: msa/filteridentity_sequences
  msa_filteridentity_sequences_saved:
    type: File[]
    outputSource: msa/filteridentity_sequences_saved
  msa_usearch2_objs:
    type: File[]
    outputSource: msa/usearch2_objs
  msa_filterclustering_sequences:
    type: File[]
    outputSource: msa/filterclustering_sequences
  msa_filterclustering_sequences_saved:
    type: File[]
    outputSource: msa/filterclustering_sequences_saved
  msa_filtercoverage_seqeunces:
    type: File[]
    outputSource: msa/filtercoverage_seqeunces
  msa_filtercoverage_seqeunces_saved:
    type: File[]
    outputSource: msa/filtercoverage_seqeunces_saved
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
    out: [msa_queries, msa_factories, msa_conf, blast_xmls, blast_ids, blast_id_sequences, blast_sequences, blast_full_sequences, blast_saved_sequences, usearch1_objs, filteridentity_sequences, filteridentity_sequences_saved, usearch2_objs, filterclustering_sequences, filterclustering_sequences_saved, filtercoverage_seqeunces, filtercoverage_seqeunces_saved, msa_objs, old_msa_obj, new_msa_obj]
