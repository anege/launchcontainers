
export root_raw_data_dir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/images
export project_dir=/export/home/agurtubay/agurtubay/Projects/Dysthal
export scripts_dir=$project_dir/1_pipe_scripts/launchcontainers
export raw_data_dir=$project_dir/2_raw_data
export analy_dir=$project_dir/3_analysis


subj_nrs="$(seq -f "%03g" 1 91)"
arr_new_subjects=( ${subj_nrs} ) #convert string to array
subjects=$(echo ${arr_new_subjects[@]/#/sub-}) # prepend sub-  #${CATEGORIES[@]/%/ bar} to append
subSestxt=$raw_data_dir/subSesList.txt

echo -e "sub,ses,RUN,anat,dwi,func" >> $subSestxt 

for subject in $subjects; do

    if [ -d $raw_data_dir/NII/${subject}/ses-T01/anat ]; then
        anat_exist=True
    else
        anat_exist=False
    fi

    if [ -d $raw_data_dir/NII/${subject}/ses-T01/dwi ]; then
        dwi_exist=True
    else
        dwi_exist=False
    fi

    echo -e ${subject}",T01,False,"$anat_exist","${dwi_exist}",False" >> $subSestxt


done