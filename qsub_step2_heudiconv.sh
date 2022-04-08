#!/bin/bash

export root_raw_data_dir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/images
export project_dir=/export/home/agurtubay/agurtubay/Projects/Dysthal
export scripts_dir=$project_dir/1_pipe_scripts/launchcontainers
export raw_data_dir=$project_dir/2_raw_data
export analy_dir=$project_dir/3_analysis
export error_dir=$analy_dir/error


if [ ! -d $error_dir ] ;then
    mkdir $error_dir
fi 

subjects=$(cat $raw_data_dir/subjects.txt)


for subject in $subjects; do

  #export subj=$subject
  error=$error_dir/$subject.txt #output error file

  echo "###### WORKING ON SUBJECT $subject ######"
  qsub -q veryshort.q \
    -l mem_free=16G \
    -e $error \
    -o $error \
    -N heudiconv_${subject} \
    $scripts_dir/step2_heudiconv_IPS.sh $subject

done
