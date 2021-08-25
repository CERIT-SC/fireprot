#!/usr/bin/env python3

from fasta import Fasta
from fastawriter import FastaWriter
from fastareader import FastaReader
from seqinfo import SeqInfo
import pickle
import sys

def extractSequences(file: str, iteration_id: str, sequence_keys: list[str]):
    fastas = FastaReader(file).readAll()
    writer = FastaWriter("full_seqs_" + iteration_id + ".fasta")
    writer.setAddLineBetweenSequences()

    sequence_index = 0
    for fasta in fastas:
        if sequence_index >= len(sequence_keys):
            raise "Unable to load all hits from database"
        origId = sequence_keys[sequence_index]
        newId = fasta.getHeader()

        if not origId in newId:
            raise "Unable to load all hits from database"

        fasta.setHeader(origId)
        writer.writeFasta(fasta)
        sequence_index += 1
    writer.close()

input_file = sys.argv[1]
sequences_in_file = sys.argv[2]

with open(sequences_in_file, 'rb') as sequences_file:
    sequences = pickle.load(sequences_file)

iteration_id = input_file.split('_')[-1].split('.')[0]

extractSequences(input_file, iteration_id, list(sequences.keys()))
