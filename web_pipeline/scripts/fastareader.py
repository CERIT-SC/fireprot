#!/usr/bin/env python3

from fasta import Fasta
import re

class FastaReader:
    def __init__(self, target: str):
        self.target = target

    def buildFasta(self, header: str, sequence: str):
        if len(sequence) == 0:
            raise "Sequence cannot be empty!"
        return Fasta(header, sequence)

    def fastaFromLines(self, lines: list[str], start: int):
        header = ''
        sequence = ''
        retindex = start - 1
        for line in lines[start:]:
            retindex += 1
            if line[0] == Fasta.HEADER_SYMBOL:
                if len(header) != 0:
                    return retindex, self.buildFasta(header, sequence)
                header = line
            else:
                sequence += re.sub(r'\s+', '', line)
        retindex += 1
        if len(header) == 0:
            return retindex, None
        return retindex, self.buildFasta(header, sequence)

    def readAll(self):
        fastas = []
        lines = open(self.target, 'r').readlines()
        index = 0
        while index < len(lines):
            index, fasta = self.fastaFromLines(lines, index)
            if fasta == None:
                raise "Invalid fasta!"
            fastas.append(fasta)
        return fastas

