#!/bin/bash

## This will fit the tensor to the aligned dwi data using FSL dtifit(https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FDT/UserGuide#DTIFIT).

dwi=`jq -r '.dwi' config.json`;
bvals=`jq -r '.bvals' config.json`;
bvecs=`jq -r '.bvecs' config.json`;

cp ${dwi} dwi.nii.gz;
cp ${bvals} dwi.bvals;
cp ${bvecs} dwi.bvecs;

if [ -f "nodif_acpc_L1.nii.gz" ];then
	echo "File exists. Skipping tensor fit"
else
	echo "Fitting tensor model"
	## create b0 image
	select_dwi_vols \
		dwi.nii.gz \
		dwi.bvals \
		nodif_acpc.nii.gz \
		0;

	## Create mean b0 image
	fslmaths nodif_acpc.nii.gz \
		-Tmean \
		nodif_acpc_mean;

	## creates brainmask for DTIFIT
	bet nodif_acpc_mean.nii.gz \
		nodif_acpc_mean_brain \
		-f 0.4 \
		-g 0 \
		-m;

	## fits tensor model
	dtifit --data=dwi \
		--out=nodif_acpc \
		--mask=nodif_acpc_mean_brain_mask \
		--bvecs=dwi.bvecs \
		--bvals=dwi.bvals;

	ret=$?
	if [ ! $ret -eq 0 ]; then
		echo "Tensor fit failed"
		echo $ret > finished
		exit $ret
	fi
fi

fslmaths nodif_acpc_L2.nii.gz -add nodif_acpc_L3.nii.gz -div 2 rd.nii.gz;

cp -v nodif_acpc_FA.nii.gz fa.nii.gz
cp -v nodif_acpc_MD.nii.gz md.nii.gz
cp -v nodif_acpc_L1.nii.gz ad.nii.gz;
rm -rf *nodif*;
rm -rf *dwi.*;

echo "Tensor Fit Complete"
