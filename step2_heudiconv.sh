export container_dir=/export/home/agurtubay/agurtubay/Projects/containers
export basedir=/export/home/agurtubay/agurtubay/Projects/Dysthal_qMRI/2_raw_data
export subj=048_DYSTHAL_06LH4_003
export sess=T01

module load singularity/3.5.2

# singularity options:
# basedir : where your dicom files are
# heudiconv container file

# see heudiconv arguments here: https://heudiconv.readthedocs.io/en/latest/usage.html#commandline-arguments
# --dicom_dir_template where to read the dicom
# --outdir where to write the nifti
# --subjects list of subjects

# Then run it after we create the Nifti/code/convertall.py file
singularity run --bind /bcbl:/bcbl \
	        --bind  ${basedir}:/base \
			$container_dir/heudiconv_0.8.0.sif \
			--dicom_dir_template /base/DCM/{subject}/*/*/*.dcm \
			--outdir /base/NII/ \
			--heuristic /base/NII/code/convertall_ANE.py \
			--subjects ${subj} \
			--ses ${sess} \
			--converter dcm2niix \
			--bids \
			--minmeta \
			--grouping all \
			--overwrite
