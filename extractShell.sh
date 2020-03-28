#!/bin/bash

dwi=`jq -r '.dwi' config.json`
bvals=`jq -r '.bvals' config.json`
bvecs=`jq -r '.bvecs' config.json`
shell=`jq -r '.shell' config.json`

dwiextract ${dwi} dwi.nii.gz -singleshell -shells 0,${shell} -fslgrad ${bvecs} ${bvals} -export_grad_fsl dwi.bvecs dwi.bvals -force -nthreads 8
