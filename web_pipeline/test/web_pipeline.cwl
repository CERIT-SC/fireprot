#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: Workflow
inputs:
  pdb:
    type: File
  pdb_renumbered:
    type: File
  #TODO config
outputs:
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
  map:
    run: mapindexes.cwl
    in:
      pdb: pdb
      pdb_renumbered: pdb_renumbered
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
