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
