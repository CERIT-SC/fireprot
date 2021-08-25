#!/usr/bin/env python3

import protein
from fastawriter import FastaWriter

class MsaFactory:
    def __init__(self, chainCluster: list[protein.ProteinChain], query: str, file_id: int):
        self.cluster = chainCluster
        self.query = query
        self.saveFasta(file_id)
    def setEvalue(self, evalue):
        self.evalue = evalue
    def setMinimalSize(self, size):
        self.minSize = size
    def setMaximalSize(self, size):
        self.maxSize = size
    def setMinimalIdentity(self, identity):
        self.minIdentity = identity
    def setMaximalIdentity(self, identity):
        self.maxIdentity = identity
    def setClusteringThreshold(self, threshold):
        self.clusteringThreshold = threshold
    def saveFasta(self, file_id):
        writer = FastaWriter("query_{}.fasta".format(file_id))
        writer.writeQuery(self.query)
        writer.close()
