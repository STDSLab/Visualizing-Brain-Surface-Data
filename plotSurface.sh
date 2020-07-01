#!/usr/bin/env bash


# the file containing the regions to plot
region_infile=${1:-region.txt}

# the dlabel file of the parcellation
dlabel_infile=$2

# scene file that specifies the view of the surface image
scene_file=$3

img_name=${4:-brain_image}
img_width=${5:-900}
img_height=${6:-700}

# path to the folder containing dlabel file of the parcellation
src_path=scene_files

# the name of the revised dlabel file
dlabel_outfile=${src_path}/region.dlabel.nii

# temporary files to be created 
oldlabel_file=fnxkasd_old.txt
newlabel_file=fnxkasd_new.txt

# remove temp file if exist
if [[ -e $oldlabel_file ]]; then
    rm $oldlabel_file
fi

if [[ -e $newlabel_file ]]; then
    rm $newlabel_file
fi

# export label map from an dlabel input
wb_command -cifti-label-export-table ${dlabel_infile} 1 ${oldlabel_file}

# read the region file
regions=()
while IFS='' read -r line || [[ -n "$line" ]]; do
  regions+=($line)
done < ${region_infile}

# echo ${regions[@]}

# read the label and write modified label map to file
line_num=1
region_num=0
while IFS='' read -r line || [[ -n "$line" ]]; do
    id=$((line_num/2))
    if [[ $((line_num % 2)) == 0 ]]; then
        if [[ ! " ${regions[@]} " =~ " ${id} " ]]; then
            echo $((line_num/2)) 0 0 0 0 >> ${newlabel_file}
        else
#            echo $((line_num/2)) ${cmap[region_num]} >> ${newlabel_file}
#            let region_num=region_num+1
            echo "$line" >> ${newlabel_file}
        fi
    else
        echo "$line" >> ${newlabel_file}
    fi

    let line_num=line_num+1
done < $oldlabel_file

# make new dlabel file
wb_command -cifti-label-import $dlabel_infile $newlabel_file $dlabel_outfile

# remove temp files
rm $oldlabel_file $newlabel_file

# write image to file
wb_command -show-scene ${scene_file} $scene_num ${img_name}.png ${img_width} ${img_height}

#
# # create new map
# wb_command -cifti-label-import ${label_file} maptable.txt newmap2.dlabel.nii
