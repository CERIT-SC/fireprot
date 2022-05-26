#!/bin/bash

if [ -z "$INPUT_PDB_PATH" ] ; then
    echo "Must provide \$INPUT_PDB_PATH"
    exit 1
fi

if [ -z "$JOB_XML_PATH" ] ; then
    echo "Must provide \$JOB_XML_PATH"
    exit 1
fi

curl -X POST --header 'Content-Type: multipart/form-data' --header 'Accept: application/problem+json' -v -F 'workflow_url=https://github.com/CERIT-SC/fireprot/blob/dev/fireprot.cwl' -F 'workflow_type=CWL' -F 'workflow_type_version=v1.0' -F "workflow_params={\"pdb\":{\"class\":\"File\",\"path\":\"ftp://ntc.ics.muni.cz/upload/$INPUT_PDB_PATH\"}, \"job_config\":{\"class\":\"File\",\"path\":\"ftp://ntc.ics.muni.cz/upload/$JOB_XML_PATH\"}}" https://wes-na.cloud.e-infra.cz/ga4gh/wes/v1/runs
