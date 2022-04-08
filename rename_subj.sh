export root_raw_data_dir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/images
export project_dir=/export/home/agurtubay/agurtubay/Projects/Dysthal
export scripts_dir=$project_dir/1_pipe_scripts/launchcontainers
export raw_data_dir=$project_dir/2_raw_data
export analy_dir=$project_dir/3_analysis
export error_dir=$analy_dir/error
rename_table=$raw_data_dir/rename_table.txt

subjs=$(cat $raw_data_dir/subjects.txt)
subjects="${subjs//_}" #remove lower score from variable
echo $subjects

k=1

echo "Rename directories"

for subject in $subjects; do
    echo "Previous name : ${subject}"

    files=$(ls $raw_data_dir/NII/sub-${subject}/ses-T01/anat/sub-${subject}_ses-T01_*)
    files+=' '$(ls $raw_data_dir/NII/sub-${subject}/ses-T01/dwi/sub-${subject}_ses-T01_*)
    files+=' '$(ls $raw_data_dir/NII/sub-${subject}/ses-T01/sub-${subject}*)

    for file in $files; do

        prev_dir="${file%/*}"

        subj_nr=$(echo $(printf "%0.3d" $k))

        new_dir="${prev_dir//${subject}/$subj_nr}"

        mkdir -p ${new_dir} #create parent directory

        mv $file ${file//${subject}/$subj_nr} #${string//substring/replacement}  #cannot move if directory doesn't exist

    done

    echo -e "${subject} > $subj_nr" >> $rename_table #print k with 3 digits(%0.3d)

    k=$(( $k+1 ))

    rm -r $raw_data_dir/NII/sub-${subject}/
                                   
done

echo "Rename files in scans.tsv"

subjs=$(cat $raw_data_dir/subjects.txt)
prev_subjects="${subjs//_}" #remove lower score from variable
arr_prev_subjects=( ${prev_subjects} ) #convert string to array

subj_nrs="$(seq -f "%03g" 1 91)"
arr_new_subjects=( ${subj_nrs} ) #convert string to array


for i in $(seq 0 ${#arr_prev_subjects[@]}); do

    echo "SUBJECT=${arr_new_subjects[$i]}"
    scans=$raw_data_dir/NII/sub-${arr_new_subjects[$i]}/ses-T01/sub-${arr_new_subjects[$i]}_ses-T01_scans.tsv

    sed -i "s/${arr_prev_subjects[$i]}/${arr_new_subjects[$i]}/g" $scans 
    

done
