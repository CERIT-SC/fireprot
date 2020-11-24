#!/bin/bash
#PBS -q loslab@elixir-pbs.elixir-czech.cz

echo $(( $RANDOM % 10 )) > $outDir/$jobName

