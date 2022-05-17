#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: bash
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/foldx:v0.02
  ResourceRequirement:
    coresMin: 2
    coresMax: 4
    ramMin: 2048
    tmpdirMin: 4096
    tmpdirMax: 16384
    outdirMin: 4096
    outdirMax: 16384
inputs:
  batches:
    type: File[]
  pdb:
    type: File
arguments:
  - prefix: -c
    valueFrom: |
        mkdir /tmp/calc && ln -sf $(inputs.pdb.path) /tmp/calc/input.pdb;
        for positions in $(inputs.batches.map(function(batch){return batch.path}).join(" ")) ; do
            ID=`echo "\$positions" | sed "s/.*_//" | sed "s/\\..*\$//"`
            mkdir "output_\${ID}"
            for position in \$(cat \$positions); do
                [ -z "\$position" ] && continue

                pos=\$(echo \$position | cut -d: -f1)
                aas=\$(echo \$position | cut -d: -f2)
                posID=\${pos::-1}

                echo "=> Calculating position \${pos} with AAs \${aas}"

                foldx --command=PssmStability --pdb-dir=/tmp/calc --pdb=input.pdb --rotabaseLocation=/usr/local/bin/rotabase.txt --output-dir="output_\${ID}" --water=CRYSTAL --pH=7 --numberOfRuns=5 --positions=\${pos} --aminoacids=\${aas} > "output_\${ID}/stdout" 2> "output_\${ID}/stderr" || exit \$?

                cp "output_\${ID}/individual_list_0_PSSM.txt" "individual_list_0_PSSM_\${ID}.\${posID}.txt"
                for f in output_\${ID}/Average_*.fxout ; do
                  cp "\${f}" \$(echo \$f | sed "s/.fxout/_\${ID}.\${posID}.fxout/" | sed "s/output_\${ID}.//")
                done
            done
        done
outputs:
  individuals:
    type: File[]
    outputBinding:
      glob: ./*.txt
  averages:
    type: File[]
    outputBinding:
      glob: ./*.fxout

