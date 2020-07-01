#!/bin/sh

#  plotDscalar.sh
#  
#
#  Created by Anh Dang on 6/28/20.
#  

# path to the folder containing dlabel file of the parcellation
src_path=scene_files

# dscalar input file
input_file=${1:-${src_path}/standard.dscalar.nii}

# scene file that specifies the view of the surface image
scene_file=${2:-${src_path}/template_dscalar.scene}

img_name=${3:-brain_image}
img_width=${4:-900}
img_height=${5:-700}

# create temp dscalar file as a copy of the input
cp $input_file ${src_path}/temp.dscalar.nii

# write image to file
/Applications/workbench/bin_macosx64/wb_command -show-scene ${scene_file} 1 ${img_name}.png ${img_width} ${img_height}

# delete temp dscalar
rm ${src_path}/temp.dscalar.nii
