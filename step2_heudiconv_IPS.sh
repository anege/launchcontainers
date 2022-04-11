#!/bin/bash
#$ -q long.q
#$ -o out.txt
#$ -e err.txt
#$ -M a.gurtubay@bcbl.eu
#$ -N heudiconv
#$ -S /bin/bash
#$ -m be


#INPUT VARIABLES
subj=$1

container_dir=/export/home/agurtubay/agurtubay/Projects/containers
export basedir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/images # basedir : where your dicom files are
export outdir=/export/home/agurtubay/agurtubay/Projects/Dysthal/2_raw_data/NII
export scripts_dir=/export/home/agurtubay/agurtubay/Projects/Dysthal/1_pipe_scripts/launchcontainers
export sess=T01 #session

module load singularity/3.5.2

# singularity options:
# basedir : where your dicom files are
# heudiconv container file

# see heudiconv arguments here: https://heudiconv.readthedocs.io/en/latest/usage.html#commandline-arguments
# --dicom_dir_template where to read the dicom
# --outdir where to write the nifti
# --subjects list of subjects (we will run all subjs in parallel)
# --converter none, only generates convertall.py. If we set it to dcm2niix, it generated the nii and the converterall.py


# Then run it after we create the Nifti/code/convertall.py file
singularity run --bind /bcbl:/bcbl \
	        --bind  ${basedir}:/base \
			$container_dir/heudiconv_latest.sif \
			--dicom_dir_template /base/{subject}/*/*/*.dcm \
			--outdir ${outdir}/ \
			--heuristic ${scripts_dir}/convertall_ANE.py \
			--subjects ${subj} \
			--ses ${sess} \
			--converter dcm2niix \
			--bids \
			--minmeta \
			--grouping all \
			--overwrite
