
export root_raw_data_dir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/images
export project_dir=/export/home/agurtubay/agurtubay/Projects/Dysthal
export scripts_dir=$project_dir/1_pipe_scripts/launchcontainers
export raw_data_dir=$project_dir/2_raw_data
export analy_dir=$project_dir/3_analysis
export error_dir=$analy_dir/error


# # subjects
subj_nrs="$(seq -f "%03g" 1 91)"
arr=( ${subj_nrs} ) #convert string to array
array=( "${arr[@]/#/sub-}" ) #preprend sub-
subjects=$(echo $( IFS=$' '; echo "${array[*]}" )) #convert array to string
echo $subjects


for subject in $subjects; do

    #echo "SUBJECT=$subject"

    scans=$raw_data_dir/NII/${subject}/ses-T01/${subject}_ses-T01_scans.tsv
    tmpfile=$project_dir/2_raw_data/tmp.txt

    #save names and acq_time to file
    cat ${scans}|awk '{if (NR!=1) {print $1","$2}}' > $tmpfile 

    k=1
    while IFS=$',\n' read -r valueX valueY; do 
        #printf 'Value1:%q\tValue2:%q\tValue3: %q\n' "$value1" "$value2" "$value3"
        names[$k]=$valueX
        acq_times[$k]=$valueY       
        k=$k+1;
    done <$tmpfile 
    # echo "all names: ${names[@]}"
    # echo "2nd name: ${names[2]}"
    # echo "all times: ${acq_times[@]}"
    # echo "2nd time:${acq_times[2]}"
    unset IFS

    # date of diffusion data acquisition. WE will filter the T1s not acquired this day
    for i in $(seq 1 ${#names[@]}); do
        if [[ ${names[$i]} == *"acq-AP"* ]]; then
            good_acq_date=${acq_times[$i]:0:10} 
        fi
    done
    # echo ${good_acq_date}
    

    #see if any T1 has the same acq date than that of diff
    for i in $(seq 1 ${#names[@]}); do
        if [[ ${acq_times[$i]:0:10} == "$good_acq_date" ]] && [[ ${names[$i]} == *"T1w2"* ]]; then
            keep=${names[$i]} 
        fi
    done

   if [[ ${#keep[@]} == 0 ]]; then
        for i in $(seq 1 ${#names[@]}); do
            if [[ ${acq_times[$i]:0:10} == "$good_acq_date" ]] && [[ ${names[$i]} == *"T1w1"* ]]; then
            keep=${names[$i]} 
            fi
        done
    fi

    if [[ ${#keep[@]} == 0 ]]; then
        for i in $(seq 1 ${#names[@]}); do
            if [[ ${acq_times[$i]:0:10} == "$good_acq_date" ]] && [[ ${names[$i]} == *"T1w."* ]]; then
            keep=${names[$i]} 
            fi
        done
    fi

    if [[ ${#keep[@]} != 0 ]]; then
        echo "$keep has same acq_date as dwi"
    elif [[ ${#keep[@]} == 0 ]]; then # If none T1 has the same acq date
        for i in $(seq 1 ${#names[@]}); do
            if [[ ${names[$i]} == *"T1w2"* ]]; then
                keep=${names[$i]} 
                break
            elif [[ ${names[$i]} == *"T1w1"* ]]; then
                keep=${names[$i]} 
                break
            elif [[ ${names[$i]} == *"T1w."* ]]; then
                keep=${names[$i]} 
                break
            fi
        done 
        echo "$keep does not have the same acq_date as T1"
    fi
    

    #select names that have t1w but not keep
    delete=''
    for i in $(seq 1 ${#names[@]}); do
        if [[ ${names[$i]} == *"T1w2"* ]] && [[ ${names[$i]} != $keep ]]; then
            delete+=' '${names[$i]}
        elif [[ ${names[$i]} == *"T1w1"* ]] && [[ ${names[$i]} != $keep ]]; then
            delete+=' '${names[$i]}
        elif [[ ${names[$i]} == *"T1w."* ]] && [[ ${names[$i]} != $keep ]]; then
            delete+=' '${names[$i]}
        fi
    done

    echo "SUBJECT $subject, KEEP: $keep DELETE: $delete"

    for del in $delete ; do
        rm $raw_data_dir/NII/${subject}/ses-T01/${del:0:-7}.nii.gz
        rm $raw_data_dir/NII/${subject}/ses-T01/${del:0:-7}.json
    done

   # find -type f -name '*text*' -delete

    rm $tmpfile
    unset good_acq_date
    unset names
    unset acq_times
    unset delete
    unset keep
    unset del


    #rename T1w2 or T1w2 => T1w
done #subj


echo "rename all T1s to T1w"
for subject in $subjects; do

    if [ -d  $raw_data_dir/NII/${subject} ]; then #if directory exists

        a=$(ls $raw_data_dir/NII/${subject}/ses-T01/anat/*.json)
        b=$(ls $raw_data_dir/NII/${subject}/ses-T01/anat/*.nii.gz)

        mv $a ${a:0:105}.json
        mv $b ${b:0:105}.nii.gz

    fi

done





