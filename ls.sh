#!/bin/bash
#PBS -q loslab@elixir-pbs.elixir-czech.cz

ls -l `cat $outDir/path.txt` > $outDir/stdout 2> $outDir/stderr

