#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
requirements:
    InlineJavascriptRequirement: {}
    MultipleInputFeatureRequirement: {}
inputs:
  new_obj:
    type: File
  job_config:
    type: File
  minimized_pdb:
    type: File
  filter_min_cst:
    type: File
  btc_type:
    type: string
    default: "btc"
  energy_type:
    type: string
    default: "energy"
  combined_type:
    type: string
    default: "combined"

outputs:
  btc_multi_mut_txt:
    type: File
    outputSource: multi_start/btc_multi_mut_txt
  combined_multi_mut_txt:
    type: File
    outputSource: multi_start/combined_multi_mut_txt
  energy_multi_mut_txt:
    type: File
    outputSource: multi_start/energy_multi_mut_txt
  btc_mut_size:
    type: int
    outputSource: multi_start/btc_mut_size
  combined_mut_size:
    type: int
    outputSource: multi_start/combined_mut_size
  energy_mut_size:
    type: int
    outputSource: multi_start/energy_mut_size
  multimutants_new:
    type: File
    outputSource: combined_multi_end/multi_end_new_obj
  btc_ddg_predictions_out:
    type: File
    outputSource: rosetta_16_btc/ddg_predictions_out
  btc_mutations_pdb_zip:
    type: File
    outputSource: rosetta_16_btc/mutations_pdb_zip
  btc_repacked_pdb_zip:
    type: File
    outputSource: rosetta_16_btc/repacked_pdb_zip
  btc_wt_traj:
    type: File
    outputSource: rosetta_16_btc/wt_traj
  btc_rosetta_stdout:
    type: File
    outputSource: rosetta_16_btc/stdout
  btc_rosetta_stderr:
    type: File
    outputSource: rosetta_16_btc/stderr
  energy_ddg_predictions_out:
    type: File
    outputSource: rosetta_16_energy/ddg_predictions_out
  energy_mutations_pdb_zip:
    type: File
    outputSource: rosetta_16_energy/mutations_pdb_zip
  energy_repacked_pdb_zip:
    type: File
    outputSource: rosetta_16_energy/repacked_pdb_zip
  energy_wt_traj:
    type: File
    outputSource: rosetta_16_energy/wt_traj
  energy_rosetta_stdout:
    type: File
    outputSource: rosetta_16_energy/stdout
  energy_rosetta_stderr:
    type: File
    outputSource: rosetta_16_energy/stderr
  combined_ddg_predictions_out:
    type: File
    outputSource: rosetta_16_combined/ddg_predictions_out
  combined_mutations_pdb_zip:
    type: File
    outputSource: rosetta_16_combined/mutations_pdb_zip
  combined_repacked_pdb_zip:
    type: File
    outputSource: rosetta_16_combined/repacked_pdb_zip
  combined_wt_traj:
    type: File
    outputSource: rosetta_16_combined/wt_traj
  combined_rosetta_stdout:
    type: File
    outputSource: rosetta_16_combined/stdout
  combined_rosetta_stderr:
    type: File
    outputSource: rosetta_16_combined/stderr
  btc_best_structure:
    type: string
    outputSource: btc_multi_end/best_structure
  btc_pdb_update:
    type: File
    outputSource: btc_multi_end/pdb_update
  btc_multi_double:
    type: double
    outputSource: btc_multi_end/multi_double
  btc_mutations_string:
    type: string
    outputSource: btc_multi_end/mutations_string
  energy_best_structure:
    type: string
    outputSource: energy_multi_end/best_structure
  energy_pdb_update:
    type: File
    outputSource: energy_multi_end/pdb_update
  energy_multi_double:
    type: double
    outputSource: energy_multi_end/multi_double
  energy_mutations_string:
    type: string
    outputSource: energy_multi_end/mutations_string
  combined_best_structure:
    type: string
    outputSource: combined_multi_end/best_structure
  combined_pdb_update:
    type: File
    outputSource: combined_multi_end/pdb_update
  combined_multi_double:
    type: double
    outputSource: combined_multi_end/multi_double
  combined_mutations_string:
    type: string
    outputSource: combined_multi_end/mutations_string

steps:
  multi_start:
    run: multimutants/multi_start.cwl
    in:
      new_obj: new_obj
      job_config: job_config
    out: [btc_multi_mut_txt, combined_multi_mut_txt, energy_multi_mut_txt, btc_mut_size, combined_mut_size, energy_mut_size, multi_start_new_obj]
  rosetta_16_btc:
    run: multimutants/rosetta_16.cwl
    in:
      mutations_txt: multi_start/btc_multi_mut_txt
      pdb_file: minimized_pdb
      cst_file: filter_min_cst
    out: [ddg_predictions_out, mutations_pdb_zip, repacked_pdb_zip, wt_traj, stdout, stderr]
  rosetta_16_energy:
    run: multimutants/rosetta_16.cwl
    in:
      mutations_txt: multi_start/energy_multi_mut_txt
      pdb_file: minimized_pdb
      cst_file: filter_min_cst
    out: [ddg_predictions_out, mutations_pdb_zip, repacked_pdb_zip, wt_traj, stdout, stderr]
  rosetta_16_combined:
    run: multimutants/rosetta_16.cwl
    in:
      mutations_txt: multi_start/combined_multi_mut_txt
      pdb_file: minimized_pdb
      cst_file: filter_min_cst
    out: [ddg_predictions_out, mutations_pdb_zip, repacked_pdb_zip, wt_traj, stdout, stderr]
  btc_multi_end:
    run: multimutants/multi_end.cwl
    in:
      new_obj: multi_start/multi_start_new_obj
      job_config: job_config
      type: btc_type
      ddg_predictions: rosetta_16_btc/ddg_predictions_out
      size: multi_start/btc_mut_size
      stdout: rosetta_16_btc/stdout
      minimized_pdb: minimized_pdb
      mutations_zip: rosetta_16_btc/mutations_pdb_zip
    out: [multi_end_new_obj, best_structure, pdb_update, multi_double, mutations_string]
  energy_multi_end:
    run: multimutants/multi_end.cwl
    in:
      new_obj: btc_multi_end/multi_end_new_obj
      job_config: job_config
      type: energy_type
      ddg_predictions: rosetta_16_energy/ddg_predictions_out
      size: multi_start/energy_mut_size
      stdout: rosetta_16_energy/stdout
      minimized_pdb: minimized_pdb
      mutations_zip: rosetta_16_energy/mutations_pdb_zip
    out: [multi_end_new_obj, best_structure, pdb_update, multi_double, mutations_string]
  combined_multi_end:
    run: multimutants/multi_end.cwl
    in:
      new_obj: energy_multi_end/multi_end_new_obj
      job_config: job_config
      type: combined_type
      ddg_predictions: rosetta_16_combined/ddg_predictions_out
      size: multi_start/combined_mut_size
      stdout: rosetta_16_combined/stdout
      minimized_pdb: minimized_pdb
      mutations_zip: rosetta_16_combined/mutations_pdb_zip
    out: [multi_end_new_obj, best_structure, pdb_update, multi_double, mutations_string]
