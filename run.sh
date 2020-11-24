#!/bin/bash

token=''

curl -X POST --header 'Content-Type: multipart/form-data'     --header 'Accept: application/json'     -F workflow_params='{"input":{"class":"File","path":"ftp://ntc.ics.muni.cz/upload/foivos/test.txt"}}'     -F workflow_type='CWL'     -F workflow_type_version='v1.0'     -F workflow_url='https://github.com/uniqueg/cwl-example-workflows/blob/master/hashsplitter-workflow.cwl'   --header "Authorization: Bearer $token"     'https://elixir-wes.cerit-sc.cz/ga4gh/wes/v1/runs'
