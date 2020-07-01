# USAGE
#


using PyCall
py"""
import os
import nibabel as nib
import numpy as np
import csv

# creates a new dscalar file 'out_fn' using the header structure of 'dscalar_fn' and sets the first layer to the values
#   specified in 'surf_vals'
def write_to_cifti(dscalar_fn, surf_vals, out_fn):
    surfScalarCifti = nib.load(dscalar_fn)
    scalarShape = surfScalarCifti.shape
    if surf_vals.shape[1] == scalarShape[1]:
        writeData = np.zeros(scalarShape)
        writeData[:1] = surf_vals

        newCifti = nib.cifti2.cifti2.Cifti2Image(dataobj = writeData, header = surfScalarCifti._header, nifti_header = surfScalarCifti._nifti_header)
        newCifti.update_headers()
        newCifti.to_filename(out_fn)
    else:
        print(surf_vals.shape[1], " ", scalarShape[1])
        print("Surface length does not match with input values!")
        print("Aborting!")

def create_sur_vals(region_vals_infile, dlabel_infile, dscalar_infile, outfile):
    surfLabelCifti = nib.load(dlabel_infile)
    surfLabel = surfLabelCifti.get_fdata()
    newSurfData = np.full(surfLabel.shape, 0.001)
    voxValList = []
    with open(region_vals_infile, "r") as f:
        reader = csv.reader(f)
        for row in reader:
            # convert txt numbers into region, edge pairs
            edgeValList.append(tuple(map(float, row)))

    for (idx, val) in voxValList:
        # # go through each region label and set to edge value
        # for idx, lb in enumerate(surfLabel[0]):
        #     if lb == reg:
        newSurfData[0, idx] = val
    # run write_to_cifti to generate the new imag efile
    write_to_cifti(dscalar_infile, newSurfData, outfile)
"""

function createDscalar(region_vals_infile, dlabel_infile, dscalar_infile, toplot=true, outfile="dscalar_out.dscalar.nii")
    py"create_sur_vals"(region_vals_infile, dlabel_infile, dscalar_infile, outfile)

    # plot image
    if toplot
        run(`./plotDscalar.sh`)
    end

    return nothing
end

if len(ARGS) > 0
    createDscalar(ARGS[1], ARGS[2], ARGS[3])
end
