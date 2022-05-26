#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
requirements:
    InlineJavascriptRequirement: {}
    SubworkflowFeatureRequirement: {}
    MultipleInputFeatureRequirement: {}
inputs:
  pdb:
    type: File
  job_config:
    type: File
  config:
    type: File
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
  msa_queries:
    type: File[]
    outputSource: msa/msa_queries
  msa_factories:
    type: File[]
    outputSource: msa/msa_factories
  msa_conf:
    type: File
    outputSource: msa/msa_conf
  msa_blast_xmls:
    type: File[]
    outputSource: msa/blast_xmls
  msa_blast_ids_ids:
    type: File[]
    outputSource: msa/blast_ids_ids
  msa_blast_id_sequences:
    type: File[]
    outputSource: msa/blast_id_sequences
  msa_blast_sequences_sequences:
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
  msa_objs:
    type: File[]
    outputSource: msa/msa_objs
  msa_old_obj:
    type: File
    outputSource: msa/old_msa_obj
  msa_new_obj:
    type: File
    outputSource: msa/new_msa_obj
  conservation_new_obj:
    type: File
    outputSource: conservation_analysis/conservation_new
  btc_new_obj:
    type: File
    outputSource: btc/btc_new
  cmanalysis_fodors:
    type: File[]
    outputSource: cmanalysis/fodors
  cmanalysis_freecontacts:
    type: File[]
    outputSource: cmanalysis/freecontacts
  cmanalysis_amic_round1_outputs:
    type: File[]
    outputSource: cmanalysis/amic_round1_outputs
  cmanalysis_amic_round2_outputs:
    type: File[]
    outputSource: cmanalysis/amic_round2_outputs
  cmanalysis_amic_round3_outputs:
    type: File[]
    outputSource: cmanalysis/amic_round3_outputs
  cmanalysis_amic_parser_old:
    type: File
    outputSource: cmanalysis/amic_parser_old
  cmanalysis_freecontacts_dca:
    type: File[]
    outputSource: cmanalysis/freecontacts_dca
  cmanalysis_csvs:
    type: File[]
    outputSource: cmanalysis/csvs
  cmanalysis_old_obj:
    type: File
    outputSource: cmanalysis/cma_old
  cmanalysis_new_obj:
    type: File
    outputSource: cmanalysis/cma_new
  stability_stability_new:
    type: File
    outputSource: stability/stability_new
  stability_foldx_individuals_zip:
    type: File
    outputSource: stability/foldx_individuals_zip
  stability_foldx_averages_zip:
    type: File
    outputSource: stability/foldx_averages_zip
  stability_btc_mutations_txt_zip:
    type: File
    outputSource: stability/btc_mutations_txt_zip
  stability_energy_mutations_txt_zip:
    type: File
    outputSource: stability/energy_mutations_txt_zip
  stability_combined_mutations_txt_zip:
    type: File
    outputSource: stability/combined_mutations_txt_zip
  stability_single_mutations_txt_zip:
    type: File
    outputSource: stability/single_mutations_txt_zip
  stability_single_ddg_predictions_zip:
    type: File
    outputSource: stability/single_ddg_predictions_zip
  stability_btc_ddg_predictions_zip:
    type: File
    outputSource: stability/btc_ddg_predictions_zip
  stability_energy_ddg_predictions_zip:
    type: File
    outputSource: stability/energy_ddg_predictions_zip
  stability_combined_ddg_predictions_zip:
    type: File
    outputSource: stability/combined_ddg_predictions_zip
  multimutants_btc_multi_mut_txt:
    type: File
    outputSource: multimutants/btc_multi_mut_txt
  multimutants_combined_multi_mut_txt:
    type: File
    outputSource: multimutants/combined_multi_mut_txt
  multimutants_energy_multi_mut_txt:
    type: File
    outputSource: multimutants/energy_multi_mut_txt
  multimutants_multimutants_new:
    type: File
    outputSource: multimutants/multimutants_new
  multimutants_btc_ddg_predictions_out:
    type: File
    outputSource: multimutants/btc_ddg_predictions_out
  multimutants_btc_mutations_pdb_zip:
    type: File
    outputSource: multimutants/btc_mutations_pdb_zip
  multimutants_btc_repacked_pdb_zip:
    type: File
    outputSource: multimutants/btc_repacked_pdb_zip
  multimutants_btc_wt_traj:
    type: File
    outputSource: multimutants/btc_wt_traj
  multimutants_btc_rosetta_stdout:
    type: File
    outputSource: multimutants/btc_rosetta_stdout
  multimutants_btc_rosetta_stderr:
    type: File
    outputSource: multimutants/btc_rosetta_stderr
  multimutants_energy_ddg_predictions_out:
    type: File
    outputSource: multimutants/energy_ddg_predictions_out
  multimutants_energy_mutations_pdb_zip:
    type: File
    outputSource: multimutants/energy_mutations_pdb_zip
  multimutants_energy_repacked_pdb_zip:
    type: File
    outputSource: multimutants/energy_repacked_pdb_zip
  multimutants_energy_wt_traj:
    type: File
    outputSource: multimutants/energy_wt_traj
  multimutants_energy_rosetta_stdout:
    type: File
    outputSource: multimutants/energy_rosetta_stdout
  multimutants_energy_rosetta_stderr:
    type: File
    outputSource: multimutants/energy_rosetta_stderr
  multimutants_combined_ddg_predictions_out:
    type: File
    outputSource: multimutants/combined_ddg_predictions_out
  multimutants_combined_mutations_pdb_zip:
    type: File
    outputSource: multimutants/combined_mutations_pdb_zip
  multimutants_combined_repacked_pdb_zip:
    type: File
    outputSource: multimutants/combined_repacked_pdb_zip
  multimutants_combined_wt_traj:
    type: File
    outputSource: multimutants/combined_wt_traj
  multimutants_combined_rosetta_stdout:
    type: File
    outputSource: multimutants/combined_rosetta_stdout
  multimutants_combined_rosetta_stderr:
    type: File
    outputSource: multimutants/combined_rosetta_stderr
  multimutants_btc_pdb_update:
    type: File
    outputSource: multimutants/btc_pdb_update
  multimutants_energy_pdb_update:
    type: File
    outputSource: multimutants/energy_pdb_update
  multimutants_combined_pdb_update:
    type: File
    outputSource: multimutants/combined_pdb_update
  output_tex:
    type: File
    outputSource: output/output_tex
  output_pdf:
    type: File
    outputSource: output/output_pdf

steps:
  preparation:
    run: preparation.cwl
    in:
      pdb: pdb
      config: config
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
  stability:
    run: stability.cwl
    in:
      new_obj: cmanalysis/cma_new
      job_config: job_config
      indexes: preparation/map_indexes
      minimized_pdb: preparation/minimize_renumbered
      filter_min_cst: preparation/filter_min_cst
    out: [stability_new, foldx_individuals_zip, foldx_averages_zip, btc_mutations_txt_zip, energy_mutations_txt_zip, combined_mutations_txt_zip, single_mutations_txt_zip, single_ddg_predictions_zip, btc_ddg_predictions_zip, energy_ddg_predictions_zip, combined_ddg_predictions_zip]
  multimutants:
    run: multimutants.cwl
    in:
      new_obj: stability/stability_new
      job_config: job_config
      minimized_pdb: preparation/minimize_renumbered
      filter_min_cst: preparation/filter_min_cst
    out: [btc_multi_mut_txt, combined_multi_mut_txt, energy_multi_mut_txt, btc_mut_size, combined_mut_size, energy_mut_size, multimutants_new, btc_ddg_predictions_out, btc_mutations_pdb_zip, btc_repacked_pdb_zip, btc_wt_traj, btc_rosetta_stdout, btc_rosetta_stderr, energy_ddg_predictions_out, energy_mutations_pdb_zip, energy_repacked_pdb_zip, energy_wt_traj, energy_rosetta_stdout, energy_rosetta_stderr, combined_ddg_predictions_out, combined_mutations_pdb_zip, combined_repacked_pdb_zip, combined_wt_traj, combined_rosetta_stdout, combined_rosetta_stderr, btc_best_structure, btc_pdb_update, btc_multi_double, btc_mutations_string, energy_best_structure, energy_pdb_update, energy_multi_double, energy_mutations_string, combined_best_structure, combined_pdb_update, combined_multi_double, combined_mutations_string]
  output:
    run: output.cwl
    in:
      new_obj: multimutants/multimutants_new
      btc_multi_size: multimutants/btc_mut_size
      btc_multi_double: multimutants/btc_multi_double
      btc_mutations: multimutants/btc_mutations_string
      energy_multi_size: multimutants/energy_mut_size
      energy_multi_double: multimutants/energy_multi_double
      energy_mutations: multimutants/energy_mutations_string
      combined_multi_size: multimutants/combined_mut_size
      combined_multi_double: multimutants/combined_multi_double
      combined_mutations: multimutants/combined_mutations_string
      indexes: preparation/map_indexes
      old_obj: cmanalysis/cma_old
    out: [output_tex, output_pdf]
