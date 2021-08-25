#!/usr/bin/env python3

import enum

class GapType(enum.Enum):
    LINEAR = 1
    CONSTANT = 2
    AFFINE = 3

class SimpleGapPenalty:
    def __init__(self, gop, gep):
        self.gop = -abs(gop)
        self.gep = -abs(gep)
        self.setType()
    def setType(self):
        if self.gop == 0:
            self.type = GapType.LINEAR
        elif self.gep == 0:
            self.type = GapType.CONSTANT
        else:
            self.type = GapType.AFFINE
    def getExtensionPenalty(self):
        return self.gep
    def getOpenPenalty(self):
        return self.gop
