#!/usr/bin/env python3

class AminoAcidCompound:
    def __init__(self, short: str, full: str, desc: str, weight: float):
        self.shortName = short
        self.longName = full
        self.description = desc
        self.molecularWeight: weight

AminoAcidCompoundSet = {
        AminoAcidCompound("A", "Ala", "Alanine", 71.0788),
        AminoAcidCompound("R", "Arg", "Arginine", 156.1875),
        AminoAcidCompound("N", "Asn", "Asparagine", 114.1039),
        AminoAcidCompound("D", "Asp", "Aspartic acid", 115.0886),
        AminoAcidCompound("C", "Cys", "Cysteine", 103.1388),
        AminoAcidCompound("E", "Glu", "Glutamic acid", 129.1155),
        AminoAcidCompound("Q", "Gln", "Glutamine", 128.1307),
        AminoAcidCompound("G", "Gly", "Glycine", 57.0519),
        AminoAcidCompound("H", "His", "Histidine", 137.1411),
        AminoAcidCompound("I", "Ile", "Isoleucine", 113.1594),
        AminoAcidCompound("L", "Leu", "Leucine", 113.1594),
        AminoAcidCompound("K", "Lys", "Lysine", 128.1741),
        AminoAcidCompound("M", "Met", "Methionine", 131.1986),
        AminoAcidCompound("F", "Phe", "Phenylalanine", 147.1766),
        AminoAcidCompound("P", "Pro", "Proline", 97.1167),
        AminoAcidCompound("S", "Ser", "Serine", 87.0782),
        AminoAcidCompound("T", "Thr", "Threonine", 101.1051),
        AminoAcidCompound("W", "Trp", "Tryptophan", 186.2132),
        AminoAcidCompound("Y", "Tyr", "Tyrosine", 163.176),
        AminoAcidCompound("V", "Val", "Valine", 99.1326),
        AminoAcidCompound("B", "Asx", "Asparagine or Aspartic acid", None),
        AminoAcidCompound("Z", "Glx", "Glutamine or Glutamic acid", None),
        AminoAcidCompound("J", "Xle", "Leucine or Isoleucine", None),
        AminoAcidCompound("X", "Xaa", "Unspecified", None),
        AminoAcidCompound("-", "---", "Unspecified", None),
        AminoAcidCompound(".", "...", "Unspecified", None),
        AminoAcidCompound("_", "___", "Unspecified", None),
        AminoAcidCompound("*", "***", "Stop", None),
        AminoAcidCompound("U", "Sec", "Selenocysteine", 150.0388),
        AminoAcidCompound("O", "Pyl", "Pyrrolysine", 255.3172)
        }

def getCompoundFromSet(search: str):
    for compound in AminoAcidCompoundSet:
        if compound.shortName == search:
            return compound
    return None

def getCompoundFromSetLong(search: str):
    for compound in AminoAcidCompoundSet:
        if compound.longName == search:
            return compound
    return None
