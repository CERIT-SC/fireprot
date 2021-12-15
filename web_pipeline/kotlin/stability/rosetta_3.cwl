#!/usr/bin/env cwl-tes
# flags for ddg 3

cwlVersion: v1.0
class: CommandLineTool
baseCommand: bash
requirements:
    InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerPull: cerit.io/rosetta:latest
  ResourceRequirement:
    coresMin: 20
    coresMax: 25
    ramMin: 20480
    ramMax: 80480
    tmpdirMin: 1024
    tmpdirMax: 16384
    outdirMin: 1024
    outdirMax: 16384
inputs:
  single_mutations_zip:
    type: File
  pdb_file:
    type: File
  cst_file:
    type: File

arguments:
  - prefix: -c
    valueFrom: |
        apt update && apt install unzip zip -y
        unzip $(inputs.single_mutations_zip.path)
        mkdir output
        ARRAY=(\$(ls single*))
        ARRLEN=\${#ARRAY[@]}
        CPUCORES=20
        INCREASE=\$((ARRLEN / CPUCORES))
        for f in \$(seq 0 \$((CPUCORES - 2))) ; do
            mkdir "worker_\${f}"
            cd "worker_\${f}"
            for g in \$(seq \$((f*INCREASE)) \$(((f+1) * INCREASE - 1))) ; do
                single="../\${ARRAY[\$g]}"
                ID=`echo "\$single" | sed "s/.*single_mutation_//" | sed "s/\\.txt\$//"`
                ddg_monomer.static.linuxgccrelease -in:file:s $(inputs.pdb_file.path) -ddg::mut_file "\${single}" -constraints::cst_file $(inputs.cst_file.path) -ddg::minimization_scorefunction "talaris2014.wts" -ddg::iterations 50 -ddg::weight_file soft_rep_design -ddg::local_opt_only true -ddg::mean false -ddg::min true -ddg::output_silent false -fa_max_dis 9.0 -ddg::dump_pdbs true -ignore_unrecognized_res -in::file::fullatom -ddg::minimization_scorefunction /opt/rosetta_bin_linux_2019.35.60890_bundle/main/database/scoring/weights/talaris2014.wts -ddg::minimization_patch > "stdout" 2> "stderr" || exit \$?

                mv "ddg_predictions.out" "../output/ddg_predictions_\${ID}.out"
                find . -maxdepth 1 -type f -iname "*.pdb" | while read r ; do mv "\$r" ../output/"\$(echo \$r | sed "s/.pdb\$/\$ID.pdb/")" ; done
                find . -maxdepth 1 -type f -exec rm "{}" \;
                if [ \$g == \$(((f+1) * INCREASE - 1)) ] ; then
                   echo "DONE" > "../CPU_\$g"
                fi
            done &
            cd ..
        done
        mkdir "worker_\${CPUCORES}"
        cd "worker_\${CPUCORES}"
        for g in \$(seq \$(((CPUCORES-1)*INCREASE)) \$((ARRLEN - 1))) ; do
            single="../\${ARRAY[\$g]}"
            ID=`echo "\$single" | sed "s/.*single_mutation_//" | sed "s/\\.txt\$//"`
            ddg_monomer.static.linuxgccrelease -in:file:s $(inputs.pdb_file.path) -ddg::mut_file "\${single}" -constraints::cst_file $(inputs.cst_file.path) -ddg::minimization_scorefunction "talaris2014.wts" -ddg::iterations 50 -ddg::weight_file soft_rep_design -ddg::local_opt_only true -ddg::mean false -ddg::min true -ddg::output_silent false -fa_max_dis 9.0 -ddg::dump_pdbs true -ignore_unrecognized_res -in::file::fullatom -ddg::minimization_scorefunction /opt/rosetta_bin_linux_2019.35.60890_bundle/main/database/scoring/weights/talaris2014.wts -ddg::minimization_patch > "stdout" 2> "stderr" || exit \$?

            mv "ddg_predictions.out" "../output/ddg_predictions_\${ID}.out"
            find . -maxdepth 1 -type f -iname "*.pdb" | while read r ; do mv "\$r" ../output/"\$(echo \$r | sed "s/.pdb\$/\$ID.pdb/")" ; done
            find . -maxdepth 1 -type f -exec rm "{}" \;
        done
        cd ..
        while [ \$(ls CPU_* | wc -l) -lt \$((CPUCORES - 1)) ] ; do
            sleep 0.1
        done
        cd output
        zip ../ddg_predictions.zip *
outputs:
  ddg_predictions:
    type: File
    outputBinding:
      glob: ddg_predictions.zip
