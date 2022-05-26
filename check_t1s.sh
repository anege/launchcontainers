
#This script informs about number of dicoms in T1 folder per subject (a lot of duplicates)

export root_raw_data_dir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/images
export project_dir=/export/home/agurtubay/agurtubay/Projects/Dysthal
export scripts_dir=$project_dir/1_pipe_scripts/launchcontainers
export raw_data_dir=$project_dir/2_raw_data
export analy_dir=$project_dir/3_analysis
export error_dir=$analy_dir/error
export txt_output=$analy_dir/t1_folders_dcms

echo "Write first line of output file"
echo -e "Number of dicoms in T1 folder per subject (a lot of duplicates)" >> $txt_output

craneo_nums="1 2"

subjs=$(cat $raw_data_dir/subjects.txt)
# subjs="002_DYSTHAL_01LH5_077 0032_DYSTHAL_03DBH1_012"


for subject in $subjs; do

    for craneo_num in $craneo_nums; do

    if [ -d $root_raw_data_dir/${subject}/*$craneo_num ]; then

        cran_dir="$root_raw_data_dir/${subject}/CRANEO_FUNCIONAL - $craneo_num"
        
        array=( $(ls -d $root_raw_data_dir/${subject}/*$craneo_num/t1_mprage*) )
        
        mp_dirs=$(expr ${#array[@]} / 3)
        printf "SUBJECT: ${subject}, CRANEO dir $craneo_num => $mp_dirs MPRAGE dirs \n" >>$txt_output


        if (( ${#array[@]} == "3" )); then
                 mprage_dirs[0]="${array[0]} ${array[1]} ${array[2]}"
                 mprage_dir_rng="0"
        elif (( ${#array[@]} == "6" )); then
                 mprage_dirs[0]="${array[0]} ${array[1]} ${array[2]}"
                 mprage_dirs[1]="${array[3]} ${array[4]} ${array[5]}"
                 mprage_dir_rng="0 1"
        elif (( ${#array[@]} == "9" )); then
                 mprage_dirs[0]="${array[0]} ${array[1]} ${array[2]}"
                 mprage_dirs[1]="${array[3]} ${array[4]} ${array[5]}"
                 mprage_dirs[2]="${array[6]} ${array[7]} ${array[8]}"
                 mprage_dir_rng="0 1 2"
        fi

        for mprage_dir_num in ${mprage_dir_rng}; do

            IFS=""
            dcm=$( ls -1q ${mprage_dirs[$mprage_dir_num]} | wc -l ) #count number of files
            unset IFS

                printf "SUBJECT: ${subject}, CRANEO dir $craneo_num, MPRAGE dir ${mprage_dirs[$mprage_dir_num]##*1iso_}, dcms $dcm \n" >>$txt_output

        done
            
    fi

    done
    unset mprage_dirs dcm array dcm

done



#####################################################################

# subjects="sub-001 sub-002 sub-003 sub-004 sub-005 sub-006 sub-007 sub-008 sub-009 sub-011 sub-012 sub-013 sub-014 sub-015 sub-016 sub-017 sub-018 sub-019 sub-020 sub-021 sub-022 sub-023 sub-024 sub-025 sub-026 sub-027 sub-028 sub-029 sub-030 sub-031 sub-032 sub-033 sub-034 sub-035 sub-037 sub-038 sub-039 sub-040 sub-041 sub-042 sub-043 sub-044 sub-045 sub-046 sub-047 sub-048 sub-049 sub-050 sub-051 sub-052 sub-053 sub-054 sub-055 sub-056 sub-057 sub-058 sub-059 sub-060 sub-061 sub-062 sub-063 sub-064 sub-065 sub-066 sub-067 sub-068 sub-069 sub-070 sub-071 sub-072 sub-074 sub-075 sub-076 sub-077 sub-078 sub-079 sub-080 sub-081 sub-082 sub-083 sub-084 sub-085 sub-086 sub-087 sub-088 sub-089 sub-090 sub-091"

# for subject in $subjects ; do
# vglrun mrview /export/home/agurtubay/agurtubay/Projects/Dysthal/2_raw_data/NII/$subject/ses-T01/anat/${subject}_ses-T01_T1w.nii.gz \
# -mode 2 -intensity_range 0,1000
# done

