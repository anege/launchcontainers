git checkbasedir=/export/home/agurtubay/agurtubay/Projects/Dysthal_qMRI/2_raw_data
export subj=048_DYSTHAL_06LH4_003
export sess=T01

module load singularity/3.5.2
# Then run it after we create the Nifti/code/convertall.py file
singularity run --bind /bcbl:/bcbl \
	        --bind  ${basedir}:/base \ #basedir : where your dicom files are
		$container_dir/heudiconv_0.5.4.sif \ #container file location. you have to point this to where your huediconv container is
		--dicom_dir_template /base/DCM/${subj}/*1/t1*5/*.dcm \
		--outdir /base/NII/ \
		--heuristic /base/NII/code/convertall.py \
		--subjects ${subj} \
		--ses ${sess} \
		--converter dcm2niix \
		--bids \
		--minmeta \
		--grouping all \
		--overwrite
