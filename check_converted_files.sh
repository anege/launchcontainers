
export root_raw_data_dir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/images
export project_dir=/export/home/agurtubay/agurtubay/Projects/Dysthal
export scripts_dir=$project_dir/1_pipe_scripts/launchcontainers
export raw_data_dir=$project_dir/2_raw_data
export analy_dir=$project_dir/3_analysis
export error_dir=$analy_dir/error


subjs=$(cat $raw_data_dir/subjects.txt)
subjects="${subjs//_}" #remove lower score from name

for subject in $subjects; do
    echo "SUBJECT: ${subject}"

    if [ ! -d $raw_data_dir/NII/sub-${subject}/*/anat ]; then
        echo "T1 not found for subject: ${subject}"
    fi
    if [ ! -d $raw_data_dir/NII/sub-${subject}/*/dwi ]; then
        echo "DWI not found for subject: ${subject}"
    fi

done
