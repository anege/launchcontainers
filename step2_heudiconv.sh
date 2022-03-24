
export basedir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/images
export subj=002_DYSTHAL_01LH5_077
export sess=T01

module load singularity/3.5.2
# Then run it after we create the Nifti/code/convertall.py file
singularity run --bind /bcbl:/bcbl \
	        --bind  ${basedir}:/base \
		~/glerma/software/heudiconv \
		--dicom_dir_template /base/Dicoms/{subject}/*/*.dcm \
		--outdir /base/Nifti/ \
		--heuristic /base/Nifti/code/convertall.py \
		--subjects ${subj} \
		--ses ${sess} \
		--converter dcm2niix \
		--bids \
		--minmeta \
		--grouping all \
		--overwrite
