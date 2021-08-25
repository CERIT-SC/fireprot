#!/usr/bin/env python3

import pickle
import xml.etree.ElementTree as ET
import sequence
import sys
from msafactory import MsaFactory
from seqinfo import SeqInfo

class BlastHsp:
    def __init__(self):
        self.num = 0
        self.eValue = 0.0
        self.identity = 0
        self.alignLength = 0
        self.sequence = ""
    def parseXMLElement(self, hsp):
        for node in hsp:
            if node.tag == "Hsp_num":
                self.num = int(node.text)
            elif node.tag == "Hsp_align-len":
                self.alignLength = int(node.text)
            elif node.tag == "Hsp_hseq":
                self.sequence = node.text
            elif node.tag == "Hsp_identity":
                self.identity = int(node.text)
            elif node.tag == "Hsp_evalue":
                self.eValue = float(node.text)
    def getSequenceWithoutGaps(self):
        return sequence.removeGapsFromSequence(self.sequence)
    def getAlignmentLength(self):
        return self.alignLength

class BlastHit:
    def __init__(self):
        self.num = 0
        self.id = ""
        self.accession = ""
        self.length = 0
        self.alternatives = {}
        self.hsps = []
        self.hitDef = ""
    def parseXMLElement(self, hit):
        self.hsps = set()
        for node in hit:
            if node.tag == "Hit_id":
                self.id = node.text
            elif node.tag == "Hit_def":
                hitDef = node.text
                for token in hitDef.split('>')[1:]:
                    hitId = token.split(' ')
                    if(len(hitId) > 1):
                        self.alternatives[hitId[0]] = hitId[1]
                    else:
                        self.alternatives[hitId[0]] = None
                self.hitDef = hitDef.split('>')[0]
            elif node.tag == "Hit_len":
                self.length = int(node.text)
            elif node.tag == "Hit_num":
                self.num = int(node.text)
            elif node.tag == "Hit_hsps":
                for hsp_node in node:
                    if hsp_node.tag == "Hsp":
                        hsp = BlastHsp()
                        hsp.parseXMLElement(hsp_node)
                        self.hsps.add(hsp)
            elif node.tag == "Hit_accession":
                self.accession = node.text
        self.hsps = list(self.hsps)
        self.hsps.sort(key=lambda entry: entry.num)
    def getHsps(self):
        return self.hsps
    def getId(self):
        return self.id


class BlastIteration:
    def __init__(self):
        self.num = 0
        self.queryId = ""
        self.queryDef = ""
        self.queryLen = 0
        self.alternatives = {}
        self.hits = []
    def parseXMLElement(self, iteration):
        self.hits = set()
        for node in iteration:
            if node.tag == "Iteration_query-ID":
                self.queryId = node.text
            elif node.tag == "Iteration_query-def":
                hitDef = node.text
                for token in hitDef.split('>')[1:]:
                    hitId = token.split(' ')
                    if(len(hitId) > 1):
                        self.alternatives[hitId[0]] = hitId[1]
                    else:
                        self.alternatives[hitId[0]] = None
                self.queryDef = hitDef.split('>')[0]
            elif node.tag == "Iteration_query-len":
                self.queryLen = int(node.text)
            elif node.tag == "Iteration_hits":
                for hit_node in node:
                    if hit_node.tag == "Hit":
                        hit = BlastHit()
                        hit.parseXMLElement(hit_node)
                        self.hits.add(hit)
            elif node.tag == "Iteration_iter-num":
                self.num = int(node.text)
        self.hits = list(self.hits)
        self.hits.sort(key=lambda entry: entry.num)
    def getHits(self):
        return self.hits


class BlastResult:
    def __init__(self):
        self.program = ""
        self.version = ""
        self.db = ""
        self.queryId = ""
        self.queryDef = ""
        self.queryLength = 0
        self.alternatives = {}
        self.iterations = []
    def loadXML(self, file):
        tree = ET.parse(file)
        root = tree.getroot()
        self.iterations = set()
        for node in root:
            if node.tag == "BlastOutput_iterations":
                for iteration in node:
                    if iteration.tag == "Iteration":
                        it = BlastIteration()
                        it.parseXMLElement(iteration)
                        self.iterations.add(it)
            elif node.tag == "BlastOutput_program":
                self.program = node.text
            elif node.tag == "BlastOutput_query-ID":
                self.queryId = node.text
            elif node.tag == "BlastOutput_db":
                self.db = node.text
            elif node.tag == "BlastOutput_query-def":
                self.queryDef = node.text
            elif node.tag == "BlastOutput_query-len":
                self.queryLength = int(node.text)
            elif node.tag == "BlastOutput_version":
                self.version = node.text
        self.iterations = list(self.iterations)
        self.iterations.sort()
    def getFirstIteration(self):
        if len(self.iterations) == 0:
            return None
        return self.iterations[0]


def loadBlast(blast_file, msaFactory, iteration_id):
    blast = BlastResult()
    blast.loadXML(blast_file)
    iteration = blast.getFirstIteration();
    sequences = {}
    with open("blastids_{}.txt".format(iteration_id), "w") as blastids:
        for hit in iteration.getHits():
            for hsp in hit.getHsps():
                ac = hit.getId()
                seq = hsp.getSequenceWithoutGaps()
                coverage = hsp.getAlignmentLength() / len(msaFactory.query)

                sequences[ac] = SeqInfo(ac, seq, coverage)
                blastids.write(ac)
                blastids.write("\n")

                break
    blastids.close()
    if len(sequences) < msaFactory.minSize:
        raise "Not enough sequences found for chain cluster '{}'".format(msaFactory.cluster)
    return sequences


blast_file = sys.argv[1]
msa_in_file = sys.argv[2]

with open(msa_in_file, 'rb') as msa_file:
    msaFactory = pickle.load(msa_file)

iteration_id = blast_file.split('_')[-1].split('.')[0]

sequences = loadBlast(blast_file, msaFactory, iteration_id)
with open("sequences_{}.out".format(iteration_id), 'wb') as sequences_file:
    pickle.dump(sequences, sequences_file)
