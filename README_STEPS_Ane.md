# Basic commands:

> IMPORTANT! Once on directory containing the .git folder:    

  See existing branches. Asterisk in the branch you are right now  
`git branch`  
Create new_branch  
`git branch new-branch`  
Change the active branch to the new branch  
`git checkout new-branch` 

# STEP 0: Fork and clone repository 

![Structure](https://www.toolsqa.com/gallery/Git/2.1_Pull-Request.png)
## 0.1 Fork Gari's repository to my Github account 

Fork is not a git command, so do it manually in Github:

## 0.2 Clone it from remote to local 
Manually using Gitkraken or visual code or  
`git clone https://github.com/anege/launchcontainers`

# STEP 1: [Configure remote]( https://help.github.com/en/articles/configuring-a-remote-for-a-fork)

You must configure a remote that points to the upstream repository in Git (Gari's) to sync changes you make in a fork with the original repository. This also allows you to sync changes made in the original repository with the fork.

Logged in Broadmann, open Terminal.

List the current configured remote repository for your fork.  
`cd /bcbl/home/home_a-f/agurtubay/Projects/Dysthal/1_pipe_scripts/launchcontainers`   
`git remote -v`

Specify a new remote upstream repository that will be synced with the fork (se hace a nivel de repositorio, da igual el branch)  
`git remote add upstream https://github.com/garikoitz/launchcontainers.git`  
Verify the new upstream repository you've specified for your fork.  
`git remote -v`

# STEP 2: [Sync the fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork)

Fetch the branches and their respective commits from the upstream repository. Commits to master will be stored in a local branch, upstream/master.  
`git fetch upstream`

Check out your fork's local master branch.

`git checkout master`

Merge the changes from upstream/master into your local master branch. This brings your fork's master branch into sync with the upstream repository, without losing your local changes.

`git merge upstream/master`  
If your local branch didn't have any unique commits, Git will instead perform a "fast-forward".

# STEP 3: [Merge changes from master into your branch](https://stackabuse.com/git-merge-branch-into-master/)

Go to your branch  
`git checkout qMRI_ane`  
Merge changes  
`git merge master`

# STEP 4: Make [launchcontainers](https://github.com/garikoitz/launchcontainers/wiki/How-to-use) work
## Prerequisites: 
Docker (in lmc02) or Singularities (in IPS, cajal, DIPC). In BCBL are already installed. To install them [see here](https://github.com/garikoitz/launchcontainers/wiki/Installation )

## 0. Pull the containers from cloud to your local
Log in IPS  
`ssh agurtubay@ips-0-3`

Access a computing node  
`qlogin`

Load Singularity module  
`module load singularity/3.7.0`

Build singularity: `singularity build anatrois_4.2.7-7.1.1.sif docker://garikoitz/anatrois:4.2.7-7.1.1`

>ERROR: While performing build: packer failed to pack: while unpacking tmpfs: error unpacking rootfs: unpack layer: unpack entry: usr/bin/fixAllSegmentations: unpack to regular file: short write: write /tmp/build-temp-605206181/rootfs/usr/bin/fixAllSegmentations: no space left on device

Solution: copy container already built from Gari:  
`container_dir=/bcbl/home/home_a-f/agurtubay/Projects/containers`  
`cp /export/home/agurtubay/public/Exchange/4Ane/anatrois_4.2.7-7.1.1.sif $container_dir`  



## 1. Convert dicom to nifti in BIDS 

### 1.1 Generate convertall.py by calling heudiconv

- Install heudiconv container. [Follow instructions here](https://heudiconv.readthedocs.io/en/latest/installation.html#singularity)  
`ssh agurtubay@ips-0-3`  
`qlogin`  
`module load singularity/3.7.0`  
`cd $container_dir`  
`singularity pull docker://nipy/heudiconv:latest`

- Edit all the options in step1_emptyheudiconv.sh. This script calls singularity run, which then calls heudiconv.  
See singularity run options [here](https://sylabs.io/guides/3.1/user-guide/cli/singularity_run.html#singularity-run)  
See heudiconv options [here](https://heudiconv.readthedocs.io/en/latest/usage.html#commandline-arguments)

- Run shell script:  
`scripts_dir=/export/home/agurtubay/agurtubay/Projects/Dysthal/1_pipe_scripts/launchcontainers`  
`cd $scripts_dir`  
`bash step1_emptyheudiconv.sh`

- This will create convertall.py once (a  template) and then will use this single one file for all the subjects in the next step

>In my case it didn't create it, so I copied Mengxing's convertall.py

- Edit convertall.py to take the T1 and diff data that you want. It should take the correct data for all the subjects, so different cases need to be taken into account.  
If I have 2 folders per subject and 3 T1s per folder, I only want the T1 from the same date as the diff data

### 1.2 Convert dicom to nifti using convertall.py generated in the previous step

 Make some tests on Brodmann. Edit options in step2_heudiconv.sh and make sure it works   
`cd $scripts_dir`  
`bash step2_heudiconv.sh`

Now let's do the same in the IPS cluster:
- Edit options in in step2_heudiconv_IPS.sh  

- Run shell script through IPS:  qsub_step2.sh calls step2_heudiconv_IPS.  
`ssh agurtubay@ips-0-3`  
`qlogin`  
`cd $scripts_dir`  
`bash qsub_step2_heudiconv.sh`

- Check whether all files have been well created:  
`cd $scripts_dir`  
`bash check_converted_files.sh`
They have to match information in Raw_data_dir/Subject_data.xlsx

- Rename subjects to and keep conversion information  
`cd $scripts_dir`  
`bash rename_subj.sh`

-Some subjects have

- This will give 3 T1s in some subjects. To solve this,
Check NII/$subject/ses-T01/$subject_ses-T01_scans.tsv
and if possible only keep the anat files whose acq-time is the same as the diff  
`cd $scripts_dir`  
`bash clean_duplicated_T1.sh`

- check T1s:  
`cd $scripts_dir`
`bash check_t1s.sh`


## 2. Create symbolic links (to save space when running containers)

- Edit example_config_launchcontainer.json as specified [here](https://github.com/garikoitz/launchcontainers/wiki/How-to-use)

- Create subSesList.txt in raw_data directory:  
`cd $scripts_dir`  
`bash createSubSesList.sh`
> Names cannot begin with numbers!  


- Run createSymLinks:   
`module load python/python3.6`  
`python3 createSymLinks_Ane.py config_launchcontainer_SymLinks.json`

- It should create derivatives/$tool dir in $analysis_dir (as specified in createSunlinks_Ane.py)

- For each container, it will create different links. For anatrois container, only links anatomical data. For RTP-preproc it will link both anatomical and diff data

## 3. Launch containers: anatROIs, RTP-preproc or RTP-pipeline

- Add [config_anatrois.json](https://github.com/garikoitz/anatROIs/blob/master/example_config.json) to ~/derivatives/anatrois_4.2.7-7.1.1/analysis-AL_01/folder and edit if necessary. It has to be named 'config.json' in analysis folder. (or edit it in runSingularity.sh)

- Launch container: `python3 qsub_generic.py config_launchcontainer.json` 

> For instance, launch anatrois container:
`python3 qsub_generic_Ane.py config_launchcontainer_anatrois.json`  

- It will only run subjects specified in $raw_data/subSesList.txt

- qsub_generic.py calls qsub_generic.sh, which calls runSingularity.sh

- Add mail info to runSingularity.sh

# TIPS:

- All your computations will be put in derivatives folder.

- before RTP-preproc: set FS=true (in json file), so it uses FS mask and not the bet from FSL (bad job)

- If I want to test something in python:  
`module load python/python3.6`  
`python 3`

- To check code in container:
Enter in the container:
`cd $container_dir`  
`singularity shell anatrois_4.2.7-7.1.1.sif`  
Once inside, their codes are normally stored in  
`cd /flywheel/v0/run`

# STEP 5: Rename branch

- Go to the branch you want to rename (qMRI_ane branch) and `git branch -m new_name`. For instance:  
 `git branch -m ane_tests`   

- Delete the remote git branch in gitkraken: (delete origin/qMRI_ane branch)

- Push ane_tests, and it will ask where to push it. There you can rename the new branch






