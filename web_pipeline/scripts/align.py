#!/usr/bin/env python3

import enum
import acid

class Subproblem:
    def __init__(self, queryStart: int, targetStart: int, queryEnd: int, targetEnd: int, isAnchored: bool):
        self.queryStartIndex = queryStart
        self.targetStartIndex = targetStart
        self.queryEndIndex = queryEnd
        self.targetEndIndex = targetEnd
        self.isAnchored = isAnchored

class AlignType(enum.Enum):
    SUBSTITUTION = 0
    DELETION = 1
    INSERTION = 2

class StepType(enum.Enum):
    COMPOUND = 0
    GAP = 1

def addAmbiguousEquivalents(cache, one, two, either):
    compound_one = acid.getCompoundFromSet(one)
    compound_two = acid.getCompoundFromSet(two)
    compound_either = acid.getCompoundFromSet(either)
    cache[compound_either] = {compound_one, compound_two, compound_either}
    cache[compound_one] = {compound_one, compound_either}
    cache[compound_two] = {compound_two, compound_either}


def getEquivalents(compounds, compound):
    cache = {}
    for comp in compounds:
        cache[comp] = {comp}
    addAmbiguousEquivalents(cache, "N", "D", "B")
    addAmbiguousEquivalents(cache, "E", "Q", "Z")
    addAmbiguousEquivalents(cache, "I", "L", "J")
    
    gap1 = acid.getCompoundFromSet("-")
    gap2 = acid.getCompoundFromSet(".")
    gap3 = acid.getCompoundFromSet("_")
    cache[acid.getCompoundFromSet("X")] = {gap1, gap2, gap3}
    return cache[compound]
    

class AlignMatrix:
    def __init__(self, values, match: int, replace: int):
        self.rows = list(values)
        self.cols = self.rows[:]
        self.max = match if match > replace else replace
        self.min = match if match < replace else replace
        self.matrix = [[0] * len(self.cols)] * len(self.rows)
        for r in range(len(self.rows)):
            for c in range(len(self.cols)):
                if self.cols[c] in getEquivalents(self.rows, self.rows[r]) or self.rows[r] in getEquivalents(self.cols, self.cols[c]):
                    self.matrix[r][c] = match
                else:
                    self.matrix[r][c] = replace
    def getValue(self, row_val, col_val):
        try:
            row = self.rows.index(row_val)
            col = self.cols.index(col_val)
        except:
            row = -1
            col = -1
        if(row == -1 or col == -1):
            return self.min
        return self.matrix[row][col]
