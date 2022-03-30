export basedir=/export/home/agurtubay/agurtubay/Projects/Dysthal_qMRI/2_raw_data
# basedir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/images
export subj=048_DYSTHAL_06LH4_003
export container_dir=/export/home/agurtubay/agurtubay/Projects/containers

# basedir : where your dicom files are
# heudiconv container file directory. you have to point this to where your huediconv container is
# -d where to read the dicom
#-o where to write the nifti

# First run it empty
singularity run --bind /bcbl:/bcbl \
	        --bind ${basedir}:/base \
		${container_dir}/heudiconv_0.5.4.sif \
		-d /base/DCM/{subject}/*1/t1*5/*.dcm \
                -o /base/NII/ \
                -f convertall \
                -s ${subj} \
		--grouping studyUID \
                -c none


