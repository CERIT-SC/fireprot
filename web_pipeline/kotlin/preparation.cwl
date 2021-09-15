#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
requirements:
    InlineJavascriptRequirement: {}
inputs:
  pdb:
    type: File
outputs:
  foldx_repair:
    type: File
    outputSource: foldx/input_repair
  foldx_fxout:
    type: File
    outputSource: foldx/input_repair_fxout
  hetatm_pdb:
    type: File
    outputSource: hetatm/pdb_hetatm
  renumbered:
    type: File
    outputSource: renumber/input_renumbered
  minimize_rossetta:
    type: File
    outputSource: minimize/rossetta_out
  minimize_renumbered:
    type: File
    outputSource: minimize/input_renumbered_out
  filter_min_cst:
    type: File
    outputSource: filter/min_cst
  map_indexes:
    type: File
    outputSource: map/indexes_obj
  map_old:
    type: File
    outputSource: map/old_obj
  map_new:
    type: File
    outputSource: map/new_obj

steps:
  foldx:
    run: preparation/foldx.cwl
    in:
      pdb: pdb
    out: [input_repair, input_repair_fxout]
  hetatm:
    run: preparation/hetatm.cwl
    in:
      pdb_repaired: foldx/input_repair
    out: [pdb_hetatm]
  renumber:
    run: preparation/renumber.cwl
    in:
      pdb_hetatm: hetatm/pdb_hetatm
    out: [input_renumbered]
  minimize:
    run: preparation/minimize.cwl
    in:
      input_renumbered: renumber/input_renumbered
    out: [rossetta_out, input_renumbered_out]
  filter:
    run: preparation/filter.cwl
    in:
      rossetta_out: minimize/rossetta_out
    out: [min_cst]
  map:
    run: preparation/mapindexes.cwl
    in:
      pdb: pdb
      pdb_renumbered: minimize/input_renumbered_out
    out: [indexes_obj, old_obj, new_obj]

