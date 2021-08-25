#!/usr/bin/env python3

import enum

class ChemComp:
    class Charge(enum.Enum):
        POSITIVE = 1
        NEGATIVE = 2
        NEUTRAL = 3
        def _Protein__jsonify(charge):
            return str(charge)

    def __init__(self, letter: str, threeLetter: str, name: str, charge: Charge, standard: bool = True):
        self.letter = letter
        self.threeLetter = threeLetter
        self.name = name
        self.charge = charge
        self.isStandard = standard
    
    def getLetter(self):
        return self.letter
    def get3Letter(self):
        return self.threeLetter
    def getName(self):
        return self.name
    def getCharge(self):
        return self.charge
    def isStandard(self):
        return self.isStandard
    def isAffectingCharge(self, alt):
        return self.charge != alt.getCharge()
    def _Protein__jsonify(self):
        return self.__dict__

UNKNOWN_LETTER = 'X'
ALANINE = ChemComp('A', "Ala", "Alanine", ChemComp.Charge.NEUTRAL);
CYSTEINE = ChemComp('C', "Cys", "Cysteine", ChemComp.Charge.NEUTRAL);
ASPARTIC_ACID = ChemComp('D', "Asp", "Aspartic acid", ChemComp.Charge.NEGATIVE);
GLUTAMIC_ACID = ChemComp('E', "Glu", "Glutamic acid", ChemComp.Charge.NEGATIVE);
PHENYLALANINE = ChemComp('F', "Phe", "Phenylalanine", ChemComp.Charge.NEUTRAL);
GLYCINE = ChemComp('G', "Gly", "Glycine", ChemComp.Charge.NEUTRAL);
HISTIDINE = ChemComp('H', "His", "Histidine", ChemComp.Charge.POSITIVE);
ISOLEUCINE = ChemComp('I', "Ile", "Isoleucine", ChemComp.Charge.NEUTRAL);
LYSINE = ChemComp('K', "Lys", "Lysine", ChemComp.Charge.POSITIVE);
LEUCINE = ChemComp('L', "Leu", "Leucine", ChemComp.Charge.NEUTRAL);
METHIONINE = ChemComp('M', "Met", "Methionine", ChemComp.Charge.NEUTRAL);
SELENOMETHIONINE = ChemComp('M', "Mse", "Selenomethionine", ChemComp.Charge.NEUTRAL, False);
ASPARAGINE = ChemComp('N', "Asn", "Asparagine", ChemComp.Charge.NEUTRAL);
PYRROLYSINE = ChemComp('O', "Pyl", "Pyrrolysine", ChemComp.Charge.NEUTRAL, False);
PROLINE = ChemComp('P', "Pro", "Proline", ChemComp.Charge.NEUTRAL);
GLUTAMINE = ChemComp('Q', "Gln", "Glutamine", ChemComp.Charge.NEUTRAL);
ARGININE = ChemComp('R', "Arg", "Arginine", ChemComp.Charge.POSITIVE);
SERINE = ChemComp('S', "Ser", "Serine", ChemComp.Charge.NEUTRAL);
THREONINE = ChemComp('T', "Thr", "Threonine", ChemComp.Charge.NEUTRAL);
SELENOCYSTEINE = ChemComp('U', "Sec", "Selenocysteine", ChemComp.Charge.NEUTRAL, False);
VALINE = ChemComp('V', "Val", "Valine", ChemComp.Charge.NEUTRAL);
TRYPTOPHAN = ChemComp('W', "Trp", "Tryptophan", ChemComp.Charge.NEUTRAL);
TYROSINE = ChemComp('Y', "Tyr", "Tyrosine", ChemComp.Charge.NEUTRAL);
UNKNOWN = ChemComp('X', "Unk", "Unknown", ChemComp.Charge.NEUTRAL, False);

AMINO_ACIDS = [ALANINE, CYSTEINE, ASPARTIC_ACID, GLUTAMIC_ACID, PHENYLALANINE, GLYCINE, HISTIDINE, ISOLEUCINE, LYSINE, LEUCINE, METHIONINE, SELENOMETHIONINE, ASPARAGINE, PYRROLYSINE, PROLINE, GLUTAMINE, ARGININE, SERINE, THREONINE, SELENOCYSTEINE, VALINE, TRYPTOPHAN, TYROSINE]

STD_AMINO_ACIDS = [ALANINE, CYSTEINE, ASPARTIC_ACID, GLUTAMIC_ACID, PHENYLALANINE, GLYCINE, HISTIDINE, ISOLEUCINE, LYSINE, LEUCINE, METHIONINE, ASPARAGINE, PROLINE, GLUTAMINE, ARGININE, SERINE, THREONINE, VALINE, TRYPTOPHAN, TYROSINE]

def getCompNone(letter: str, onlyStandard: bool = False):
    options = STD_AMINO_ACIDS if onlyStandard else AMINO_ACIDS
    for comp in options:
        if letter.lower() == comp.getLetter().lower():
            return comp
    return None

def getComp(letter: str, onlyStandard: bool = False):
    comp = getCompNone(letter, onlyStandard)
    if comp != None:
        return comp
    return UNKNOWN

def get3Comp(letters: str, onlyStandard: bool = False):
    options = STD_AMINO_ACIDS if onlyStandard else AMINO_ACIDS
    for comp in options:
        if letters.lower() == comp.get3Letter().lower():
            return comp
    return UNKNOWN

def getCompoundsFromString(compoundstr: str):
    pos = 0
    result = []
    while pos < len(compoundstr):
        compound = getCompNone(compoundstr[pos])
        pos += 1
        if compound != None:
            result.append(compound)
    return result

