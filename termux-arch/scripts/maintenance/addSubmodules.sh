#!/bin/sh -e 
# Copyright 2018 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Update submodules to latest version. 
#####################################################################
git submodule update --init --recursive
scripts/maintenance/addSubmoduleScripts.sh ||:
scripts/maintenance/addSubmoduledfa.sh ||:
scripts/maintenance/addSubmoduleDocs.sh ||:
scripts/maintenance/addSubmoduleImgs.sh ||:
scripts/maintenance/addSubmodulegen.sh ||:
