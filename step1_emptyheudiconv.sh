export basedir=/export/home/agurtubay/agurtubay/Projects/Dysthal_qMRI/2_raw_data
# basedir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/images
export subj=048_DYSTHAL_06LH4_003
export container_dir=/export/home/agurtubay/agurtubay/Projects/containers

# singularity options:
# basedir : where your dicom files are
# heudiconv container file

# see heudiconv arguments here: https://heudiconv.readthedocs.io/en/latest/usage.html#commandline-arguments
# --dicom_dir_template where to read the dicom
# --outdir where to write the nifti
# --subjects list of subjects (now we only need 1 to generate the convertall.py file)
# --converter none, only generates convertall.py. If we set it to dcm2niix, it generated the nii and the converterall.py

# First run it empty
singularity run --bind /bcbl:/bcbl \
	        --bind ${basedir}:/base \
		${container_dir}/heudiconv_0.8.0.sif \
		--dicom_dir_template /base/DCM/{subject}/*/*/*.dcm \
                --outdir /base/NII/ \
                --heuristic  convertall \
                --subjects ${subj} \
		--grouping all \
                --converter none #dcm2niix

 
