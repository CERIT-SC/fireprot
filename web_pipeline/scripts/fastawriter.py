#!/usr/bin/env python3

from fasta import Fasta

class FastaWriter:
    def __init__(self, target: str):
        self.target = target
        self.aaPerLine = 80
        self.addLineBetweenSequences = False
        self.output = open(self.target, "w")

    def setAddLineBetweenSequences(self, addLine: bool = True):
        self.addLineBetweenSequences = addLine

    def writeQuery(self, query: str):
        self.writeFasta(Fasta("query", query))

    def writeFasta(self, fasta: Fasta):
        self.write(fasta.getHeader(), fasta.getSequenceSplitted(self.aaPerLine))

    def write(self, header: str, sequence: str):
        self.output.write(chr(62))
        self.output.write(header)
        self.output.write("\n")
        self.output.write(sequence)
        self.output.write("\n")
        if self.addLineBetweenSequences:
            self.output.write("\n")

    def close(self):
        self.output.close()
