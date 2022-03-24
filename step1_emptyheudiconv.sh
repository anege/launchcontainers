basedir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/images
subj=002_DYSTHAL_01LH5_077


# First run it empty
singularity run --bind /bcbl:/bcbl \
	        --bind ${basedir}:/base \
		~/glerma/software/heudiconv \
		-d /base/Dicoms/{subject}/*/*.dcm \
                -o /base/Nifti/ \
                -f convertall \
                -s ${subj} \
		--grouping all \
                -c none


