# Fireprot CWL Pipeline

This repository contains the Fireprot pipeline written in Common Workflow
Language.

This pipeline relies on the Subworkflow feature of CWL which enables us
to include multiple CWL files into one main CWL file as subworkflows.
Thanks to this feature we can divide pipelines into logical modules for
simpler maintenance.

The main pipeline file is called `fireprot.cwl`, it transitively includes
all other CWL files in this repository. CWL files in the root of this
repository are either simple command line tools (e.g. `btc.cwl`) or they
are workflows that utilize the Subworkflow feature and include CWL files
from a direcotry of the same name (e.g. `multimutants.cwl` includes all
CWL files from `multimutants`).

This repository also contains a script that starts the pipeline on
CWL-WES server running in CERIT-SC Kubernetes infrastructure.
