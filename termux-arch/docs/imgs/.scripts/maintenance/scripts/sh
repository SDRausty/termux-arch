#!/usr/bin/env sh
# Copyright 2020 (c)  all rights reserved by S D Rausty;  see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
#####################################################################
set -eu

[ -f .git/config ] && SIAD="$(grep url .git/config|cut -d"=" -f 2|head -n 1|cut -d"/" -f 2-3)"
echo $SIAD
exit
echo under construction
git remote add upstream https://github.com/WAE/covid19 ||:
git pull upstream https://github.com/WAE/covid19 ||:
git checkout master
git fetch --all
git pull --rebase upstream master
git push origin master
# upr.sh EOF
