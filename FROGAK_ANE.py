
module load python/python3.6
python3
import pandas as pd
seqinfo = pd.read_csv('/export/home/agurtubay/agurtubay/Projects/Dysthal_qMRI/2_raw_data/NII/.heudiconv/048DYSTHAL06LH4003/ses-T01/info/dicominfo_ses-T01.tsv',sep='\t')

  
  for idx, s in enumerate(seqinfo):
        if ('diff' in s.protocol_name) and (s.dim4 == 105 or s.dim4 == 210) and ('SBRef' not in s.protocol_name):
            diff_uid = s.series_uid.split("202")[1][:5]
            
            print_uid

seqinfo = pd.read_csv('/export/home/agurtubay/agurtubay/Projects/Dysthal_qMRI/2_raw_data/NII/.heudiconv/048DYSTHAL06LH4003/ses-T01/info/dicominfo_ses-T01.tsv',sep='\t')
for idx, s in seqinfo.iterrows():
    print(row["series_id"])

    OK


for idx, s in enumerate(seqinfo):
 print(row["date"])

     OK


seqinfo = pd.read_csv('/export/home/agurtubay/agurtubay/Projects/Dysthal_qMRI/2_raw_data/NII/.heudiconv/048DYSTHAL06LH4003/ses-T01/info/dicominfo_ses-T01.tsv',sep='\t')
for idx, s in enumerate(seqinfo):
 print(s.series_uid.split)
 
 print (diff_uid)


    s.series_uid.split("202")[1][:5]

https://stackoverflow.com/questions/16476924/how-to-iterate-over-rows-in-a-dataframe-in-pandas
for idx, s in enumerate(seqinfo):
    print (row['c1'], row["sex"])