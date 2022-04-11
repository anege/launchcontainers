import os

# create a function called create_key
def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes


def infotodict(seqinfo):
    # Section 1: These key definitions should be revised by the user
    ###################################################################
    # For each sequence, define a variable using the create_key function:
    # variable = create_key(output_directory_path_and_name).
    #
    # "data" creates sequential numbers which can be for naming sequences.
    # This is especially valuable if you run the same sequence multiple times at the scanner.
    data   = create_key('run-{item:03d}')
    t1w    = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_T1w')
    dwi    = create_key('sub-{subject}/{session}/dwi/sub-{subject}_{session}_acq-AP_dwi')
    dwi_PA = create_key('sub-{subject}/{session}/dwi/sub-{subject}_{session}_acq-PA_dwi')
    #ret01  = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-ret_run-01')
    #ret02  = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-ret_run-02')
    #ret03  = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-ret_run-03')

    # Section 1b: This data dictionary (below) should be revised by the user.
    # It uses the variables defines above as keys.
    ##########################################################################
    # Enter a key in the dictionary for each key you created above in section 1.
    #info = {data: [], t1w: [], dwi: [], dwi_PA: [], ret01: [], ret02: [], ret03: []}
    info = {data: [], t1w: [], dwi: [], dwi_PA: []}
    last_run = len(seqinfo)

    # Section 2: These criteria should be revised by user.
    ##########################################################
    # Define test criteria to check that each dicom sequence is correct
    # seqinfo (s) refers to information in dicominfo.tsv. Consult that file for
    # available criteria.
    # Here we use two types of criteria:
    # 1) An equivalent field "==" (e.g., good for checking dimensions)
    # 2) A field that includes a string (e.g., 'mprage' in s.protocol_name)
    for idx, s in enumerate(seqinfo):
        if ('mprage' in s.protocol_name) and ((s.dim3 == 176) or (s.dim3 == 352) or (s.dim3 == 528)): # 03magno T1 has 352
            info[t1w].append(s.series_id)
        if ('diff' in s.protocol_name) and (s.dim4 == 105 or s.dim4 == 210) and ('SBRef' not in s.protocol_name):
            info[dwi].append(s.series_id)
        if ('diff' in s.protocol_name) and (s.dim4 == 7 or s.dim4 == 14) and ('SBRef' not in s.protocol_name):
            info[dwi_PA].append(s.series_id)
        #if ('RetinotopicAtlas_Run1' in s.protocol_name)  and ('SBRef' not in s.series_description):
        #    info[ret01].append(s.series_id)
        #if ('RetinotopicAtlas_Run2' in s.protocol_name) and  ('SBRef' not in s.series_description):
        #    info[ret02].append(s.series_id)
        #if ('RetinotopicAtlas_Run3' in s.protocol_name) and  ('SBRef' not in s.series_description):
        #    info[ret03].append(s.series_id)
    return info
