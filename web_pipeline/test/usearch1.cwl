#!/usr/bin/env cwl-tes

cwlVersion: v1.0
class: CommandLineTool
baseCommand: sh 

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: cerit.io/usearch:v0.2

inputs:
  queries_fasta:
    type: File[]
  full_seqs:
    type: File[]
  min_identity:
    type: double

arguments:
  - prefix: -c
    valueFrom: |
      for f in $(inputs.queries_fasta.map(function(query){return query.path}).join(" ")) ; do
        ID=`echo "\$f" | sed "s/.*_//" | sed "s/.fasta\$//"` ;
        FULLSEQSTR="blast_sequence_\${ID}.fasta"; FULLSEQFILE="";
        for g in $(inputs.full_seqs.map(function(query){return query.path}).join(" ")) ; do
          if [ ! -z \$(echo "\$g" | grep "\$FULLSEQSTR") ] ; then FULLSEQFILE="\$g" ; fi
        done
        /usr/bin/usearch -search_global "\$f" -db "\$FULLSEQFILE" -id $(inputs.min_identity) --userout "usearch1_\${ID}.out" -userfields target+id -fulldp ; done
outputs:
  userach1_outs:
    type:
      type: array
      items: [File, Directory]
    outputBinding:
      glob: ./*.out
