#!/usr/bin/env python3

import sys
import typing
import protein
from atoms import AMINO_ATOMS
import chemcomp
import json

def load2(src_path: str) -> protein.Protein:
    atoms: dict[str,dict[str,list[str]]] = {}
    src = open(src_path, "r")
    for record in src.readlines():
        if len(record) == 0 or record[:4] != "ATOM":
            continue
        chain = record[21]
        if chain not in atoms:
            atoms[chain] = {}
        alternate = record[16]
        if alternate == ' ':
            alternate = ''
        insertion = record[26]
        if insertion == ' ':
            insertion = ''
        key = record[22:26] + alternate + insertion
        if key not in atoms[chain]:
            atoms[chain][key] = []
        atoms[chain][key].append(record)

    prot = protein.Protein()
    for chainid in atoms.keys():
        chain = protein.ProteinChain(chainid)
        seqid = 1
        indices: set[tuple[int,str]] = set()
        for records in atoms[chainid].values():
            first = records[0]
            struct_index = (int(first[22:26].strip()), '' if first[26] == ' ' else first[26])
            if struct_index in indices:
                continue
            atomnames: set[str] = set()
            for record in records:
                atomnames.add(record[13:16].strip())
            # TODO maybe print wrong atoms? ProteinIO.java:150
            residue = protein.Residue(seqid, struct_index)
            residue.setChemicalCompound(chemcomp.get3Comp(first[17:20].strip()))
            chain.addResidue(residue)
            indices.add(struct_index)
            seqid += 1
        prot.addChain(chain)
    #TODO wtf is setMinimized?!
    return prot

#pdb = load2(sys.argv[1])
