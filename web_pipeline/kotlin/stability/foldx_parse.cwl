#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: bash
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/fireprot/foldx:v0.03
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
        ARRAY=()
        mkdir /tmp/calc && ln -sf $(inputs.pdb.path) /tmp/calc/input.pdb;
        for positions in $(inputs.batches.map(function(batch){return batch.path}).join(" ")) ; do
            ARRAY+=( "\$positions" )
        done
        ARRLEN=\${#ARRAY[@]}
        CPUCORES=10
        INCREASE=\$((ARRLEN / CPUCORES))
        for f in \$(seq 0 \$((CPUCORES - 2))) ; do
            for g in \$(seq \$((f*INCREASE)) \$(((f+1) * INCREASE - 1))) ; do
                positions=\${ARRAY[\$g]}
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
                if [ \$g == \$(((f+1) * INCREASE - 1)) ] ; then
                   echo "DONE" > "CPU_\$f"
                fi
            done &
        done
        for g in \$(seq \$(((CPUCORES-1)*INCREASE)) \$((ARRLEN - 1))) ; do
            positions=\${ARRAY[\$g]}
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
        while [ \$(ls CPU_* | wc -l) -lt \$((CPUCORES - 1)) ] ; do
            sleep 0.1
        done
        zip individuals.zip *.txt
        zip averages.zip *.fxout
outputs:
  individuals_zip:
    type: File
    outputBinding:
      glob: individuals.zip
  averages_zip:
    type: File
    outputBinding:
      glob: averages.zip
