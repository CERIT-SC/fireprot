#!/usr/bin/env python3

def removeGapsFromSequence(sequence):
    ret = ""
    for c in sequence:
        if c != '-':
            ret += c
    return c
