echo "recover old or deleted files"

https://confluence.si.edu/display/HPC/How+to+Recover+Old+or+Deleted+Files+using+Snapshots

# Example, restore index.mif in fixel_templ_reor directory
# -i option prevents overwriting! so if we want to restore corrupted files, we need to erase them first or not use -identical

echo "choose the snapshot you want to restore"
cd /export/home/agurtubay/agurtubay/Projects/Dysthal/2_raw_data/NII/
cd .\snapshot
ls -l
hourly.2022-04-07_1005

echo "to copy folder..."
cd /export/home/agurtubay/agurtubay/Projects/Dysthal/2_raw_data/NII/.snapshot/hourly.2022-04-07_1005/sub-046DYSTHAL01LH4000/
destination_folder=/export/home/agurtubay/agurtubay/Projects/Dysthal/2_raw_data/NII_BERRI/sub-046DYSTHAL01LH4000/


cp -r * $destination_folder

echo "to copy file..."
# file_name=index.mif
# cp -p $file_name $destination_folder/$file_name