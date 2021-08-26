#!/usr/bin/env python3

from fastawriter import FastaWriter
from msafactory import MsaFactory
from seqinfo import SeqInfo
import sys
import pickle

def saveSequences(iteration_id: str, msaFactory: MsaFactory, sequenceValues: list[SeqInfo], prefix: str):
    writer = FastaWriter(prefix + "_" + iteration_id + ".fasta")
    writer.setAddLineBetweenSequences()
    writer.writeQuery(msaFactory.query)

    for info in sequenceValues:
        writer.write(info.ac, info.sequence)
    writer.close()

msa_in_file = sys.argv[1]
sequences_in_file = sys.argv[2]
prefix = sys.argv[3]

with open(msa_in_file, 'rb') as msa_file:
    msaFactory = pickle.load(msa_file)

with open(sequences_in_file, 'rb') as sequences_file:
    sequences = pickle.load(sequences_file)

iteration_id = msa_in_file.split('_')[-1].split('.')[0]

saveSequences(iteration_id, msaFactory, list(sequences.values()), prefix)

