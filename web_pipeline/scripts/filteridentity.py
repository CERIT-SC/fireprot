#!/usr/bin/env python3

import sys
import pickle

def filterByIdentity(sequences, usearch, maxIdentity):
    lines = open(usearch, "r").readlines()
    retain_keys = []
    for line in lines:
        if len(line) == 0:
            continue

        tokens = line.split('\t')
        if float(tokens[1]) < maxIdentity:
            retain_keys.append(tokens[0])
    return_sequences = {}
    for key in retain_keys:
        if key in sequences:
            return_sequences[key] = sequences[key]
    return return_sequences


sequences_path = sys.argv[1]
usearch_path = sys.argv[2]
maxIdentity = float(sys.argv[3])

with open(sequences_path, "rb") as sequences_file:
    sequences = pickle.load(sequences_file)

iteration_id = sequences_path.split('_')[-1].split('.')[0]

ret_seqs = filterByIdentity(sequences, usearch_path, maxIdentity)

with open("sequences_{}.out".format(iteration_id), 'wb') as sequences_file:
    pickle.dump(ret_seqs, sequences_file)
