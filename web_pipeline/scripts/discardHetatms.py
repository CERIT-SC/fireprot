#!/usr/bin/env python3

import typing
import sys

def PDBGrep(src_path: str, dest_path: str):
    src = open(src_path, "r")
    dest = open(dest_path, "w")
    for line in src.readlines():
        if line[:6] != "HETATM":
            dest.writelines([line])
    dest.close()
    src.close()

PDBGrep(sys.argv[1], "pdb_out")
