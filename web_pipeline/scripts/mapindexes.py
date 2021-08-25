#!/usr/bin/env python3

import load
import sys
from align import AlignType, AlignMatrix, Subproblem, StepType
import chemcomp
from acid import AminoAcidCompoundSet, getCompoundFromSet
import time
import protein
import json
import pickle
import gap

def getLocationsFromSteps(steps: list, max_len: int):
    locations = []
    start = 0
    oStep = 0
    oMax = max_len

    inGap = True
    for step in range(len(steps)):
        isGapStep = steps[step] == StepType.GAP
        if not isGapStep:
            oStep += 1
            if(inGap):
                inGap = False
                # TODO really +1????
                start = step + 1
        elif not inGap:
            inGap = True
            locations.append((start, step))

    if not inGap:
        locations.append((start, step+1))

#    print(step)
#    print(len(steps) - 1)
#    print(oStep)
#    print(max_len)

#    print(locations)
    if step != len(steps) - 1 or oStep != max_len:
        raise("Given sequence does not fit in alignment")

    return locations

def isGap(index: int, locations: list):
    for location in locations:
        if index >= location[0] and index <= location[1]:
            return False
    return True

def getSequenceAlignment(steps_len: int, locations: list):
    sequenceFromAlignment = []
    a = 1
    s = 1
    for i in range(locations[0][0]):
        sequenceFromAlignment.append(s)
        a += 1
#    print("STEPS_LEN: {}".format(steps_len))
    while a <= steps_len:
        if not isGap(a, locations):
            s += 1
        sequenceFromAlignment.append(s)
        a += 1
    return sequenceFromAlignment

def getCompoundAt(index: int, steps_len: int, locations: list, sequenceAlignment: list, compounds: list):
    if index >= 1 and index <= steps_len and isGap(index, locations):
        return getCompoundFromSet('-').shortName
    else:
#        print(index)
        index = sequenceAlignment[index-1]
#        print(index)
        return compounds[index-1].letter

def toStringWithSteps(string: str, steps: list):
#    print(string)
#    print(steps)
    locations = getLocationsFromSteps(steps, len(string))
#    print(locations)
    compounds_list = chemcomp.getCompoundsFromString(string)
    sequence_alignment = getSequenceAlignment(len(steps), locations)
#    print(sequence_alignment)
    result = ""
    for i in range(1, len(steps) + 1):
        result += getCompoundAt(i, len(steps), locations, sequence_alignment, compounds_list)

#    print(result)

    return result

def setSteps(traceback, local: bool, xymax, last, sx, sy):
#    print("TRACEBACK")
#    print(traceback)
#    print("END")
    x = xymax[0]
    y = xymax[1]
    linear = len(traceback[x][y]) == 1
    while True:
#        print("LAST: {}".format(last))
#        print("X: {}, Y: {}".format(x, y))
        if local:
            if (linear and last == None) or (linear and traceback[x][y][last.value] == None):
                break
        elif x <= 0 and y <= 0:
            break
        if last == AlignType.DELETION:
            sx.append(StepType.COMPOUND)
            sy.append(StepType.GAP)
            if linear:
                x -= 1
                last = traceback[x][y][0]
            else:
                last = traceback[x][y][1]
                x -= 1
        elif last == AlignType.SUBSTITUTION:
            sx.append(StepType.COMPOUND)
            sy.append(StepType.COMPOUND)
            if linear:
                x -= 1
                y -= 1
                last = traceback[x][y][0]
            else:
                last = traceback[x][y][0]
                x -= 1
                y -= 1
        elif last == AlignType.INSERTION:
            sx.append(StepType.GAP)
            sy.append(StepType.COMPOUND)
            if linear:
                y -= 1
                last = traceback[x][y][0]
            else:
                last = traceback[x][y][2]
                y -= 1
        else:
            raise("WATAFAK?! {}".format(last))
    sx.reverse()
    sy.reverse()
    return [x,y]

def setScorePoint(x: int, y: int, gop: int, gep: int, sub: int, scores):
    pointers = [None, None, None]
    if scores[x-1][y-1][1] >= scores[x-1][y-1][0] and scores[x-1][y-1][1] >= scores[x-1][y-1][2]:
        scores[x][y][0] = scores[x-1][y-1][1] + sub
        pointers[0] = AlignType.DELETION
    elif scores[x-1][y-1][0] >= scores[x-1][y-1][2]:
        scores[x][y][0] = scores[x-1][y-1][0] + sub
        pointers[0] = AlignType.SUBSTITUTION
    else:
        scores[x][y][0] = scores[x-1][y-1][2] + sub
        pointers[0] = AlignType.INSERTION

    if scores[x-1][y][1] >= scores[x-1][y][0] + gop:
        scores[x][y][1] = scores[x-1][y][1] + gep
        pointers[1] = AlignType.DELETION
    else:
        scores[x][y][1] = scores[x-1][y][0] + gop + gep
        pointers[1] = AlignType.SUBSTITUTION

    if scores[x][y - 1][0] + gop >= scores[x][y - 1][2]:
        scores[x][y][2] = scores[x][y-1][0] + gop + gep
        pointers[2] = AlignType.SUBSTITUTION
    else:
        scores[x][y][2] = scores[x][y-1][2] + gep
        pointers[2] = AlignType.INSERTION

    return pointers

def getSubstitutionScoreVector(queryColumn: int, subproblem: Subproblem, query: str, target: str, align_matrix: AlignMatrix):
    subs = [0] * (subproblem.targetEndIndex + 1)
    query_compounds = chemcomp.getCompoundsFromString(query)
    target_compounds = chemcomp.getCompoundsFromString(target)

    if queryColumn > 0:
#        print("SUBS: {}".format(len(subs)))
#        print("Q: {}".format(len(query_compounds)))
#        print("T: {}".format(len(target_compounds)))
        for y in range(max(1, subproblem.targetStartIndex), subproblem.targetEndIndex + 1):
#            print(y)
            subs[y] = align_matrix.getValue(query_compounds[queryColumn-1], target_compounds[y-1])
    return subs

def setScoringVector(x: int, subproblem: Subproblem, align_gap: gap.SimpleGapPenalty, subs: list[int], storing: bool, scores):
    pointers = [[]] * (subproblem.targetEndIndex + 1)
    # min_val = -2147483648 - gop - gep # but in java there's overflow
    gop = align_gap.getOpenPenalty()
    gep = align_gap.getExtensionPenalty()
    min_val = -2147483648 - gop - gep
    if not storing and x > 1:
        scores[x] = [[]] * (subproblem.targetEndIndex + 1)
        for i in range(subproblem.targetEndIndex + 1):
            scores[x][i] = [0,0,0]
    if x == subproblem.queryStartIndex:
        scores[subproblem.queryStartIndex][subproblem.targetStartIndex][1] = gop
        scores[subproblem.queryStartIndex][subproblem.targetStartIndex][2] = gop
        pointers[subproblem.targetStartIndex] = [None, None, None]
        for y in range(subproblem.targetStartIndex + 1, subproblem.targetEndIndex + 1):
            scores[subproblem.queryStartIndex][y][0] = min_val
            scores[subproblem.queryStartIndex][y][1] = min_val
            scores[subproblem.queryStartIndex][y][2] = scores[subproblem.queryStartIndex][y - 1][2] + gep
            pointers[y] = [None, None, AlignType.INSERTION]
    else:
        scores[x][subproblem.targetStartIndex][0] = min_val
        scores[x][subproblem.targetStartIndex][2] = min_val
        scores[x][subproblem.targetStartIndex][1] = scores[x - 1][subproblem.targetStartIndex][1] + gep
        pointers[subproblem.targetStartIndex] = [None, AlignType.DELETION, None]
        for i in range(subproblem.targetStartIndex + 1, subproblem.targetEndIndex + 1):
            pointers[i] = setScorePoint(x, i, gop, gep, subs[i], scores)
    return pointers

def align(query: str, target: str, align_matrix: AlignMatrix, align_gap: gap.SimpleGapPenalty):
    dimensions = [len(query) + 1, len(target) + 1, 3]
    scores = [[[0]]] * dimensions[0]
    scores[0] = [[0] * dimensions[2]] * dimensions[1]
    scores[1] = [[0] * dimensions[2]] * dimensions[1]
    traceback = [[[]]] * dimensions[0]
    sx = []
    sy = []
    xymax = [dimensions[0] - 1, dimensions[1] - 1]
    subproblems = [Subproblem(0, 0, xymax[0], xymax[1], False)]
    for subproblem in subproblems:
        for x in range(subproblem.queryStartIndex, subproblem.queryEndIndex + 1):
            traceback[x] = setScoringVector(x, subproblem, align_gap, getSubstitutionScoreVector(x, subproblem, query, target, align_matrix), False, scores)
    xmax = len(scores) - 1
    ymax = len(scores[xmax]) - 1
    if len(traceback[xmax][ymax]) == 1:
        last = traceback[xmax][ymax][0]
    else:
        if scores[xmax][ymax][1] > scores[xmax][ymax][0] and scores[xmax][ymax][1] > scores[xmax][ymax][2]:
            last = AlignType.DELETION
        elif scores[xmax][ymax][0] > scores[xmax][ymax][2]:
            last = AlignType.SUBSTITUTION
        else:
            last = AlignType.INSERTION
    setSteps(traceback, False, [xmax, ymax], last, sx, sy)
    score = -2147483648
    final_score = scores[xymax[0]][xymax[1]]
    score = max(score, max(final_score))
    profile = (query, target, sx, sy)
    pair = profile
    scores = []
#    print("Returning from alignment")
    return profile

def mapIndexes(old_pdb, new_pdb):
    new_index = 1
    indexes = []
    for chain in old_pdb.getChains().values():
#        print("CHAIN: {}".format(chain.id))
        align_matrix = AlignMatrix(AminoAcidCompoundSet,1,0)
        align_query = chain.getSequence()
        align_target = new_pdb.getChain(chain.getID()).getSequence()
        align_gap = gap.SimpleGapPenalty(1, 1)
        align_pair = align(align_query, align_target, align_matrix, align_gap)
        al_orig = toStringWithSteps(align_pair[0], align_pair[2])
        aligned = toStringWithSteps(align_pair[1], align_pair[3])
        counter = 0
        for residue in chain.getResidues():
            if aligned[counter] != '-':
                indexes.append(protein.ProteinIndex((new_index,''), residue.getStructureIndex(), chain.getID()))
                new_index += 1
            counter += 1
#    for index in indexes:
#        print("{} -> {}".format(index.index[0], index.old[0]))
    return indexes


old_pdb = load.load2(sys.argv[1])
new_pdb = load.load2(sys.argv[2])
# TODO read from config
old_pdb.setPDBCode("4e46")
new_pdb.setPDBCode(old_pdb.getPDBCode())

# TODO parents - proteinwrap that has info from config, should hopefully be just
# a dummy class with bools and shit (also pointers to old/new but we don't give 2 shits about those)
indexes = mapIndexes(old_pdb, new_pdb)
#print(json.dumps(indexes, default=lambda o: o.__dict__))
#print(old_pdb.toJson())
#print(new_pdb.toJson())

with open('indexes.out', 'wb') as indexes_file:
    pickle.dump(indexes, indexes_file)
with open('old.out', 'wb') as old_file:
    pickle.dump(old_pdb, old_file)
with open('new.out', 'wb') as new_file:
    pickle.dump(new_pdb, new_file)
