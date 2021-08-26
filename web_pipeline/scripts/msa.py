#!/usr/bin/env python3

import pickle
import protein
import json
import sys
from msafactory import MsaFactory

class MsaParams:
    def __init__(self, userUploaded: bool, evalue: str, size: int, minIdentity: float, maxIdentity: float, common_error: str, msa_min: int, msa_clustering: float):
        self.userUploaded = userUploaded
        self.evalue = evalue
        self.size = size
        self.minIdentity = minIdentity
        self.maxIdentity = maxIdentity
        self.commonErrorMsg = common_error
        self.msa_minSize = msa_min
        self.msa_clusteringThreshold = msa_clustering

# Note: our example input isn't useralignment, if it was this func wouldn't be used
def readParams():
    # TODO read config from XML, here we only hardcode example input
    userUploaded = False
    evalue = "1.0E-10"
    size = 200
    minIdentity = 30.0
    maxIdentity = 90.0
    commonErrorMsg = "Unable to parse calculation parameters"
    # TODO read from core.xml, again, only example input
    msa_minSize = 5
    msa_clusteringThreshold = 0.9

    return MsaParams(userUploaded, evalue, size, minIdentity, maxIdentity, commonErrorMsg, msa_minSize, msa_clusteringThreshold)

def calculate(params: MsaParams, old: protein.Protein):
    ret = True
    atLeastOne = False
    file_id = 1
    for chainCluster in old.getSameChains():
        print(file_id)
        chains = protein.chainClusterToString(chainCluster)
        if len(protein.getChainClusterRepresentantKnownOnly(chainCluster)) == 0:
            continue
        msaFactory = MsaFactory(chainCluster, protein.getChainClusterRepresentant(chainCluster).getSequence(), file_id)

        msaFactory.setEvalue(params.evalue)
        msaFactory.setMinimalSize(params.msa_minSize)
        msaFactory.setMaximalSize(params.size)
        msaFactory.setMinimalIdentity(params.minIdentity)
        msaFactory.setMaximalIdentity(params.maxIdentity)
        msaFactory.setClusteringThreshold(params.msa_clusteringThreshold)

        with open("msa_{}.factory".format(file_id), "wb") as msafactory_file:
            pickle.dump(msaFactory, msafactory_file)

        file_id += 1

def msa():
    ret = True
    params = readParams()
    ret = calculate(params, old_pdb)

#TODO sys.argv instead of hardcoded filenames
#with open('indexes.out', 'rb') as indexes_file:
#    indexes = pickle.load(indexes_file)
#with open('new.out', 'rb') as new_file:
#    new_pdb = pickle.load(new_file)

old_pdb_path = sys.argv[1]

with open(old_pdb_path, 'rb') as out_file:
    old_pdb = pickle.load(out_file)

msa()

with open("evalue.txt", "w") as evalue_file:
    evalue_file.write(readParams().evalue)
    evalue_file.close()
with open("minidentity.txt", "w") as minidentity_file:
    minidentity_file.write(readParams().minIdentity)
    minidentity_file.close()
with open("minidentityhundredth.txt", "w") as min100_file:
    min100_file.write(readParams().minIdentity / 100.0)
    min100_file.close()
with open("maxidentity.txt", "w") as maxid_file:
    maxid_file.write(readParams().maxIdentity)
    maxid_file.close()
