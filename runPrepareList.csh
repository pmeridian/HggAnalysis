#!/bin/csh
# $Id: $


if( $#argv<2  ) then
  echo "usage:  runPrepareList.csh  <list dir>   <srm directory>   [run if 1]"
  exit 0
endif

set prepareListCommand = preparelist_eth.csh

set run = 0
if( $#argv>2 ) then
  set run = $3
endif

set listdir = $1

set srmdir = $2

mkdir -p ${listdir}
lcg-ls "${srmdir}" | awk -F '/' '{print $NF}' | xargs -I {} lcg-ls "${srmdir}/{}" >> ${listdir}/allFiles.txt
cd ${listdir}/
lcg-ls "${srmdir}" | awk -F '/' '{print $NF}' | xargs -I {} ../${prepareListCommand} allFiles.txt {} ${run} > makeLists.log

if( $run != 1 ) then
  rm -rf ${list}
endif