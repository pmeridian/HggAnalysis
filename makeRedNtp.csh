#!/bin/tcsh

set listdir  = list.V8

if($#argv == 0) then
  echo "usage:  makeRedNtp.csh    <run if 1>   <queue>  <executable eg ./tmp/redntpApp>"
  exit 0
endif


# submit the job only if the 2nd argument is 1
set run = 0
if ($#argv > 0) then
  set run = $1
  echo "run : $run "
endif 

# roma
set queue = cmsshort
# cern
#set queue = 8nh

if ($#argv > 1) then
  set queue = $2
  echo "queue : $queue "
endif 

# app to run
set app = ./tmp/redntpApp

if(! -e $app ) then
  echo "missing executable $app"
  exit 0
endif 


set higgssamples = (   )
foreach i ( 90 95 100 105 110 115 120 130 140 )
  set higgssamples = ( $higgssamples VBF_HToGG_M-${i}_7TeV-powheg-pythia6_00  )
  set higgssamples = ( $higgssamples WH_ZH_TTH_HToGG_M-${i}_7TeV-pythia6_00  )
  set higgssamples = ( $higgssamples GluGluToHToGG_M-${i}_7TeV-powheg-pythia6_00  )
end

set qcdsamples = ( )
foreach i (`seq -w 0 50 `)
  set qcdsamples = ( $qcdsamples  QCD_Pt-30to40_doubleEMEnriched_TuneZ2_7TeV-pythia6_${i} )
  set qcdsamples = ( $qcdsamples  QCD_Pt-40_doubleEMEnriched_TuneZ2_7TeV-pythia6_${i} )
  #echo $qcdsamples[$i]
end

set gjetsamples = ( )
foreach i (`seq -w 0 10 `)
  set gjetsamples = ( $gjetsamples  GJet_Pt-20_doubleEMEnriched_TuneZ2_7TeV-pythia6_${i} )
end

set boxsamples = ( )
foreach i (`seq -w 0 10 `)
  set boxsamples = ( $boxsamples  DiPhotonBox_Pt10to25_TrackingParticles_7TeV-pythia6_${i} )
  set boxsamples = ( $boxsamples  DiPhotonBox_Pt25to250_TrackingParticles_7TeV-pythia6_${i} )
  set boxsamples = ( $boxsamples  DiPhotonBox_Pt250toinf_TrackingParticles_7TeV-pythia6_${i} )
end

set digammajetsamples = ( )
foreach i (`seq -w 0 10 `)
  set digammajetsamples = ( $digammajetsamples  DiPhotonJets_7TeV-madgraph_${i} )
end

set zjetssamples = ( )
foreach i (`seq -w 0 10 `)
  set zjetssamples = ( $zjetssamples  DYJetsToLL_TuneZ2_M-50_7TeV-madgraph-tauolaFall10-START38_V12-v3_${i} )
end

set run2010Bsamples = ( )
foreach i (`seq -w 0 15 `)
  set run2010Bsamples = ( $run2010Bsamples  run2010B_${i} )
end

set run2010Asamples = ( )
foreach i (`seq -w 0 42 `)
  set run2010Asamples = ( $run2010Asamples  run2010A_${i} )
end

set datasamples = ( $run2010Asamples  $run2010Bsamples )




#set samples = ( $higgssamples $datasamples $qcdsamples $gjetsamples  $boxsamples  $digammajetsamples $zjetssamples )

#set samples = ( )
#foreach i (`seq -w 0 8 `)
#  set samples = ( $samples  run2010A_0${i} )
#end

#set samples = ( )
#foreach i (`cat failed.txt`)
#  set samples = ( $samples  ${i} )
#end

set samples = ( $datasamples )


set outdir = redntp.V8
set logdir = ${outdir}/log

mkdir -p $outdir  $logdir


foreach sample ( $samples )
   set rootfile = "${outdir}/redntp_${sample}.root"
   set jobname = "${sample}"
   set logfile = "${logdir}/${sample}.txt"
   set listfile = "${listdir}/${sample}.list"
   if(! -e $listfile ) then
      #echo "skipping non-existent file $listfile"
      continue
   endif
   set command = "bsub -q ${queue} -o $logfile -J ${jobname} cd ${PWD}; ${app} ${listdir}/${sample}.list ${rootfile}"
   echo "submitted job: ${jobname}"
   #echo "   command: ${command}"
   if($run == 1) then
     ${command}
     #sleep 1
   endif
end