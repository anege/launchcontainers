
# Steps followed by Ane

## Prerequisites: 
- Docker (in lmc02) or Singularities (in IPS, cajal, DIPC). In BCBL are already installed. To install them [see here](https://github.com/garikoitz/launchcontainers/wiki/Installation )

## 0. Pull the containers from cloud to your local
- Log in IPS: 
`ssh agurtubay@ips-0-3`

- Access a computing node: `qlogin`

- Load Singularity module: `module load singularity/3.7.0`

- Build singularity: `singularity build anatrois_4.2.7-7.1.1.sif docker://garikoitz/anatrois:4.2.7-7.1.1`


    > ERROR: While performing build: packer failed to pack: while unpacking tmpfs: error unpacking rootfs: unpack layer: unpack entry: usr/bin/fixAllSegmentations: unpack to regular file: short write: write /tmp/build-temp-605206181/rootfs/usr/bin/fixAllSegmentations: no space left on device

    Solution: copy container already built from Gari: `cp /export/home/agurtubay/public/Exchange/4Ane/anatrois_4.2.7-7.1.1.sif /export/home/agurtubay/agurtubay/Projects/containers`


## 1. convert dicom to nifti in BIDS by calling heudiconv

### 1.1 generate convertall.py

- Define basedir and subject ID in step1_emptyheudiconv.sh
- run shell script: 
    
    `cd /export/home/agurtubay/agurtubay/Projects/Dysthal_qMRI/1_pipe_scripts/launchcontainers` 

    `bash step1_emptyheudiconv.sh`

### 1.2 convert using convertall.py generated in the previous step

- Define  basedir, subject ID and session ID in step2_heudiconv.sh
- run shell script: `bash step2_heudiconv.sh`


## 2. create symbolic links (to save space when running containers)
- Edit example_config_launchcontainer.json as specified [here](https://github.com/garikoitz/launchcontainers/wiki/How-to-use)
- Edit subSesList.txt
- Run createSymLinks: `python3 createSymLinks.py example_config_launchcontainer.json`

## 3. launch containers: anatROIs, RTP-preproc or RTP-pipeline.
- Launch container: `python3 qsub_generic.py example_config_launchcontainer.json` 




# NEXT...

MRF_raw_dir=/export/home/agurtubay/lab/MRI/DYSTHAL_MRI/DATA/fingerprinting






