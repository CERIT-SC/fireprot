#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
requirements:
    InlineJavascriptRequirement: {}
inputs:
  new_obj:
    type: File
  job_config:
    type: File
  indexes:
    type: File
  minimized_pdb:
    type: File
  filter_min_cst:
    type: File
outputs:
  foldx_batches:
    type: File[]
    outputSource: foldx_start/foldx_batches
  foldx_new_obj:
    type: File
    outputSource: foldx_start/foldx_new_obj
  catalytic_distance:
    type: File
    outputSource: foldx_start/catalytic_distance
  foldx_averages:
    type: File[]
    outputSource: foldx_parse/averages
  foldx_fxouts:
    type: File[]
    outputSource: foldx_parse/fxouts

steps:
  foldx_start:
    run: stability/foldx_start.cwl
    in:
      new_obj: new_obj
      job_config: job_config
      indexes: indexes
    out: [foldx_batches, foldx_new_obj, catalytic_distance]
  foldx_parse:
    run: stability/foldx_parse.cwl
    in:
      batches: foldx_start/foldx_batches
      pdb: minimized_pdb
    out: [individuals, averages]
  foldx_process:
    run stability/foldx_process.cwl
    in:
      batches: foldx_start/foldx_batches
      averages: foldx_parse/averages
      individuals: foldx_parse/individuals
      new: foldx_start/foldx_new_obj
      job_config: job_config
      indexes: indexes
    out: [btc_mutations_obj_zip, btc_mutations_txt_zip, combined_mutations_obj_zip, combined_mutations_txt_zip, single_mutations_obj_zip, single_mutations_txt_zip, mutations, btcmutations, energymutations, new_obj]
  single_rosetta:
    run: stability/rosetta_3.cwl
    in:
      mutations_txt_zip: foldx_process/single_mutations_txt_zip
      pdb_file: minimized_pdb
      cst_file: filter_min_cst
      prefix: "single"
    out: [ddg_predictions_zip]
  single_process:
    run: stability/single_process.cwl
    in:
      single_mutations_zip: foldx_process/single_mutations_obj_zip
      ddg_predictions_zip: single_rosetta/ddg_predictions_zip
      new_obj: foldx_process/new_obj
      indexes: indexes
      mutations: foldx_process/mutations
      btcmutations: foldx_process/btcmutations
      energymutations: foldx_process/energymutations
      job_config: job_config
    out: [energy_mutations_obj_zip, energy_mutations_txt_zip, combined_mutations_obj_zip, combined_mutations_txt_zip, mutations, btcmutations, energymutations, new_obj]
  btc_rosetta:
    run: stability/rosetta_3.cwl
    in:
      mutations_txt_zip: foldx_process/btc_mutations_txt_zip
      pdb_file: minimized_pdb
      cst_file: filter_min_cst
      prefix: "btc"
    out: [ddg_predictions_zip]
  btc_process:
    run: stability/pair_process.cwl
    in:
      pair_mutations_zip: foldx_process/btc_mutations_obj_zip
      ddg_predictions_zip: btc_rosetta/ddg_predictions_zip
      new_obj: single_process/new_obj
      indexes: indexes
      btcmutations: single_process/btcmutations
      energymutations: single_process/energymutations
      job_config: job_config
      pair_type: "btc"
    out: [combined_mutations_obj_zip, combined_mutations_txt_zip, btcmutations, energymutations, new_obj]
  energy_rosetta:
    run: stability/rosetta_3.cwl
    in:
      mutations_txt_zip: foldx_process/energy_mutations_txt_zip
      pdb_file: minimized_pdb
      cst_file: filter_min_cst
      prefix: "energy"
    out: [ddg_predictions_zip]
  energy_process:
    run: stability/pair_process.cwl
    in:
      pair_mutations_zip: foldx_process/energy_mutations_obj_zip
      ddg_predictions_zip: energy_rosetta/ddg_predictions_zip
      new_obj: btc_process/new_obj
      indexes: indexes
      btcmutations: btc_process/btcmutations
      energymutations: btc_process/energymutations
      job_config: job_config
      pair_type: "energy"
    out: [combined_mutations_obj_zip, combined_mutations_txt_zip, btcmutations, energymutations, new_obj]
  combine_combined_objects:
    run: stability/combine_zips.cwl
    in:
      zips: [foldx_process/combined_mutations_obj_zip, single_process/combined_mutations_obj_zip, btc_process/combined_mutations_obj_zip, energy_process/combined_mutations_obj_zip]
    out: [output_zip]
  combine_combined_text:
    run: stability/combine_zips.cwl
    in:
      zips: [foldx_process/combined_mutations_txt_zip, single_process/combined_mutations_txt_zip, btc_process/combined_mutations_txt_zip, energy_process/combined_mutations_txt_zip]
    out: [output_zip]
  combined_rosetta:
    run: stability/rosetta_3.cwl
    in:
      mutations_txt_zip: combine_combined_text/output_zip
      pdb_file: minimized_pdb
      cst_file: filter_min_cst
      prefix: "combined"
    out: [ddg_predictions_zip]
  combined_process:
    run stability/combined_process.cwl
    in:
      combined_mutations_zip: combine_combined_objects/output_zip
      ddg_predictions_zip: combined_rosetta/ddg_predictions_zip
      new_obj: energy_process/new_obj
      indexes: indexes
    out: [new_obj]
