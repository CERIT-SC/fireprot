#!/usr/bin/env python3

import chemcomp
import json
import collections

class Residue:
    def __init__(self, seqIndex: int, structIndex: tuple[int,str] = None):
        self.sequenceIndex = seqIndex
        self.structureIndex = structIndex
        self.chemicalCompound = chemcomp.UNKNOWN

    def setChemicalCompound(self, compound: chemcomp.ChemComp):
        self.chemicalCompound = compound
    def getChemicalCompound(self):
        return self.chemicalCompound
    def getSequenceIndex(self):
        return self.sequenceIndex
    def getStructureIndex(self):
        return self.structureIndex
    def _Protein__jsonify(self):
        return self.__dict__

class PairData:
    def __init__(self, mut1: str, mut2: str, stability: float, higherstab: float):
        self.mut1 = mut1
        self.mut2 = mut2
        self.stab = stability
        self.higher = higherstab

class ProteinChain:
    def __init__(self, protein_id: str):
        self.id: str = protein_id
        self.protein = None
        self.residues: map[int, Residue] = {}
        self.sequence = None
    def addResidue(self, residue: Residue):
        self.residues[residue.getSequenceIndex()] = residue
        # TODO maybe residuesByStructure? not sure if we'll need that
        self.sequence = None
    def getResidues(self):
        return collections.OrderedDict(sorted(self.residues.items())).values()
    def getID(self):
        return self.id
    def getSequence(self):
        if self.sequence == None:
            sequence = ""
            for residue in self.residues.values():
                sequence += residue.getChemicalCompound().getLetter()
        return sequence
    def _Protein__jsonify(self):
        return self.__dict__

class ProteinIndex:
    def __init__(self, struct, old, chain):
        self.index = struct
        self.old = old
        self.chain = chain

class Protein:
    def __init__(self):
        self.pdbCode: str = ""
        self.biologicalUnit: int = -1
        self.parent = None # TODO maybe add proteinwrap???
        self.btcPairs: set[PairData] = {}
        self.energyPairs: set[PairData] = {}
        self.combinedPairs: set[PairData] = {}
        self.chains: dict[str, ProteinChain] = {}
    def addChain(self, chain: ProteinChain):
        self.chains[chain.getID()] = chain
    def setPDBCode(self, code: str):
        self.pdbCode = code
    def setParent(self, parent):
        self.parent = parent
    def getPDBCode(self):
        return self.pdbCode
    def getChains(self):
        return self.chains
    def getChain(self, chain_id: str):
        return self.chains[chain_id]
    def __jsonify(self):
        return self.__dict__
    def toJson(self):
        return json.dumps(self, default=lambda o: o.__jsonify())
    def getSameChains(self):
        clusters: dict[str,list[ProteinChain]] = {}
        for chain in self.chains.values():
            sequence = chain.getSequence()
            if sequence not in clusters:
                clusters[sequence] = []
            clusters[sequence].append(chain)
        return clusters.values()

def chainClusterToString(cluster: list[ProteinChain]):
    ret = ""
    for chain in cluster:
        ret += chain.getID() + "_"
    return ret[:-1]

def getChainClusterRepresentant(cluster: list[ProteinChain]):
    return cluster[0]

def getChainClusterRepresentantKnownOnly(cluster: list[ProteinChain]):
    representant = getChainClusterRepresentant(cluster)
    sequence = representant.getSequence()
    return sequence.replace('X', '')

