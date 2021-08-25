#!/usr/bin/env python3

class Fasta:
    HEADER_SYMBOL = '>'
    RESIDUES_LINE = 80

    def __init__(self, header: str, sequence: str):
        self.header = header if header[0] != Fasta.HEADER_SYMBOL else header[1:]
        self.sequence = sequence

    def setHeader(self, header: str):
        self.header = header
    def getHeader(self):
        return self.header
    def getSequence(self):
        return self.sequence
    def getSequenceSplitted(self, limit: int):
        result = ""
        d = 1
        for i in range(len(self.sequence)):
            result += self.sequence[i]
            if d % limit == 0:
                result += "\n"
            d += 1
        return result
    def toString(self):
        return Fasta.HEADER_SYMBOL + self.header + "\n" + getSequenceSplitted(Fasta.RESIDUES_LINE)

