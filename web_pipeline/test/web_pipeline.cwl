#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
inputs:
  pdb:
    type: File
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
  blast_xmls:
    type:
      type: array
      items: [File, Directory]
    outputSource: blast/blast_xmls
  blast_ids:
    type:
      type: array
      items: [File, Directory]
    outputSource: blast_ids/blast_ids
  blast_sequences:
    type:
      type: array
      items: [File, Directory]
    outputSource: blast_sequences/blast_sequences

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
      old_out: map/old_out
    out: [queries_fasta, msa_factories, evalue]
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
    out: [blast_ids]
  blast_sequences:
    run: blast_sequences.cwl
    in:
      blast_ids: blast_ids/blast_ids
    out: [blast_sequences]
