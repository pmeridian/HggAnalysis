#!/bin/tcsh

set listdir  = list.V27.41x 
#set listdir  = list.V21

if($#argv == 0) then
  echo "usage:  makeRedNtp.csh    <run if 1>   <queue>  <selection>"
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

if ($#argv > 2) then
  set selection = $3
  echo "selection : $selection "
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
  set higgssamples = ( $higgssamples GluGluToHToGG_M-${i}_7TeV-pythia6_00  )
end

set qcdsamples = ( )
foreach i (`seq -w 0 42 `)
  set qcdsamples = ( $qcdsamples  QCD_Pt-30to40_doubleEMEnriched_TuneZ2_7TeV-pythia6_${i} )
  set qcdsamples = ( $qcdsamples  QCD_Pt-40_doubleEMEnriched_TuneZ2_7TeV-pythia6_${i} )
  #echo $qcdsamples[$i]
end

set qcdsamplesenr = ( ) 
foreach i (`seq -w 0 97 `) 
  set qcdsamplesenr = ( $qcdsamplesenr  QCD_Pt-20to30-EMEnriched_TuneZ2_7TeV-pythia6_${i} ) 
  set qcdsamplesenr = ( $qcdsamplesenr  QCD_Pt-30to80-EMEnriched_TuneZ2_7TeV-pythia6_${i} ) 
  set qcdsamplesenr = ( $qcdsamplesenr  QCD_Pt-80to170-EMEnriched_TuneZ2_7TeV-pythia6_${i} )  
  #echo $qcdsamplesenr[$i] 
end 

set gjetsamples = ( )
foreach i (`seq -w 0 11 `)
  set gjetsamples = ( $gjetsamples  GJet_Pt-20_doubleEMEnriched_TuneZ2_7TeV-pythia6_${i} )
end

set boxsamples = ( )
foreach i (`seq -w 0 10 `)
#  set boxsamples = ( $boxsamples  DiPhotonBox_Pt10to25_TrackingParticles_7TeV-pythia6_${i} )
  set boxsamples = ( $boxsamples  DiPhotonBox_Pt25to250_TrackingParticles_7TeV-pythia6_${i} )
  set boxsamples = ( $boxsamples  DiPhotonBox_Pt250toinf_TrackingParticles_7TeV-pythia6_${i} )
end

set digammajetsamples = ( )
foreach i (`seq -w 0 10 `)
  set digammajetsamples = ( $digammajetsamples  DiPhotonJets_7TeV-madgraph_${i} )
end

set zjetssamples = ( )
foreach i (`seq -w 0 10 `)
#  set zjetssamples = ( $zjetssamples  DYJetsToLL_TuneZ2_M-50_7TeV-madgraph-tauola_PU_${i} )
  set zjetssamples = ( $zjetssamples  DYJetsToLL_TuneZ2_M-50_7TeV-madgraph-tauola_${i} )
end

set run2010Bsamples = ( )
foreach i (`seq -w 0 18 `)
  set run2010Bsamples = ( $run2010Bsamples  run2010B_${i} )
end

set run2010Asamples = ( )
foreach i (`seq -w 0 58 `)
  set run2010Asamples = ( $run2010Asamples  run2010A_${i} )
end

#set run2011A_v1samples = ( )
#foreach i (`seq -w 0 3 `)
#  set run2011A_v1samples = ( $run2011A_v1samples  run2011A_v1_${i} )
#end

#set run2011A_v2samples = ( )
#foreach i (`seq -w 0 1 `)
#  set run2011A_v2samples = ( $run2011A_v2samples  run2011A_v2_${i} )
#end

#set run2011A_v2_chunck2samples = ( )
#foreach i (`seq -w 0 1 `)
#  set run2011A_v2_chunck2samples = ( $run2011A_v2_chunck2samples  run2011A_v2_chunck2_${i} )
#end

set run2011A_v1samples = ( )
foreach i (`seq -w 0 3 `)
  set run2011A_v1samples = ( $run2011A_v1samples  run2011A_v1-ESFixed_0${i} )
end

set run2011A_v2samples = ( )
foreach i (`seq -w 0 3 `)
  set run2011A_v2samples = ( $run2011A_v2samples  run2011A_v2-163078-163340_0${i} )
end

set run2011A_v2_chunck2samples = ( )
foreach i (`seq -w 0 0 `)
  set run2011A_v2_chunck2samples = ( $run2011A_v2_chunck2samples  run2011A_v2-upto-163289_0${i} )
end

 
set run2011A_v3a_samples = ( ) 
foreach i (`seq -w 0 2 `) 
  set run2011A_v3a_samples = ( $run2011A_v3a_samples  run2011A_v3a-160341-163401_0${i} ) 
end 

set run2011A_v10425samples = ( )
foreach i (`seq -w 0 1 `)
  set run2011A_v10425samples = ( $run2011A_v10425samples  run2011A_v10425_0${i} )
end

set run2011A_v20425samples = ( )
foreach i (`seq -w 0 2 `)
  set run2011A_v20425samples = ( $run2011A_v20425samples  run2011A_v20425_0${i} )
end


#set datasamples = ( $run2010Asamples $run2010Bsamples )
#set datasamples = (  $run2011A_v1samples $run2011A_v2samples $run2011A_v2_chunck2samples $run2011A_v10425samples $run2011A_v20425samples )
set datasamples = ( $run2011A_v3a_samples )


#set samples = ( $higgssamples $datasamples $gjetsamples  $boxsamples  $zjetssamples $qcdsamples )

#set samples = ( $digammajetsamples ) 
#set samples = ( $higgssamples $datasamples )


set samples = ( $datasamples )

set namedir = redntp.V27.41x.hgg
set castordir = /castor/cern.ch/user/d/delre/reduced/
set outdir = ${castordir}/${namedir}
set logdir = ${namedir}/log

rfmkdir  $outdir  
mkdir  $namedir
mkdir  $logdir


foreach sample ( $samples )
   set rootfile = "rfio:${outdir}/redntp_${sample}.root"
   set jobname = "${sample}"
   set logfile = "${logdir}/${sample}.txt"
   set listfile = "${listdir}/${sample}.list"
   if(! -e $listfile ) then
      echo "skipping non-existent file $listfile"
      continue
   endif
   set command = "bsub -q ${queue} -o $logfile -J ${jobname} cd ${PWD}; ${app} ${listdir}/${sample}.list ${rootfile} ${selection}"
   echo "submitted job: ${jobname}"
   echo "   command: ${command}"
   if($run == 1) then
     ${command}
     sleep 5
   endif
end
