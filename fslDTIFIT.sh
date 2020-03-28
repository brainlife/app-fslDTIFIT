#!/bin/bash

## This will fit the tensor to the aligned dwi data using FSL dtifit(https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FDT/UserGuide#DTIFIT).

# parse inputs
dwi=`jq -r '.dwi' config.json`;
bvals=`jq -r '.bvals' config.json`;
bvecs=`jq -r '.bvecs' config.json`;
mask=`jq -r '.mask' config.json`;
shell=`jq -r '.shell' config.json`;
multishell=`jq -r '.multishell' config.json`;
sse=`jq -r '.sse' config.json`;
wls=`jq -r '.wls' config.json`;
gradnonlin=`jq -r '.gradnonlin' config.json`;
kurtosis=`jq -r '.kurtosis' config.json`;
kurtdir=`jq -r '.kurtdir' config.json`;

mkdir -p tensor

# reset variables
[[ ${sse} == true ]] && sse="--sse" || sse=""
[[ ${wls} == true ]] && wls="--wls" || wls=""
[[ ${gradnonlin} == true ]] && gradnonlin="--gradnonlin" || gradnonlin=""
if [[ ${multishell} == true ]]; then
	[[ ${kurtosis} == true ]] && kurt="--kurt" || kurt=""
	[[ ${kurtdir} == true ]] && kurtdir="--kurtdir" || kurtdir=""
	
        [[ ! -f dwi.nii.gz ]] && echo "copy data" && cp ${dwi} dwi.nii.gz && cp ${bvals} dwi.bvals && cp ${bvecs} dwi.bvecs
else
	kurt=""
	kurtdir=""
fi

# generate brain mask if needed
if [ $mask == "null" ]; then
    echo "creating brainmask"

    ## create b0 image
	select_dwi_vols \
		dwi${shell}.nii.gz \
		dwi${shell}.bvals \
		nodif.nii.gz \
		0 \
		-m;

	## creates brainmask for DTIFIT
	bet nodif_mean.nii.gz \
		nodif_mean_brain \
		-f 0.2 \
		-g 0 \
		-m;
	mv nodif_mean_brain_mask.nii.gz mask.nii.gz
else
	cp ${mask} mask.nii.gz;
fi

## fits tensor model
echo "Fitting tensor model"
dtifit --data=dwi \
	--out=dti \
	--mask=mask \
	--bvecs=dwi.bvecs \
	--bvals=dwi.bvals \
	${kurt} \
	${kurtdir} \
	${sse} \
	${wls} \
	${gradnonlin};

# create RD
fslmaths dti_L2.nii.gz -add dti_L3.nii.gz -div 2 ./tensor/rd.nii.gz;

# clean up
cp -v dti_FA.nii.gz ./tensor/fa.nii.gz
cp -v dti_MD.nii.gz ./tensor/md.nii.gz
cp -v dti_L1.nii.gz ./tensor/ad.nii.gz;

if [[ ${multishell} == true ]]; then
	[[ ${kurtosis} == true ]] && cp dti_kurt.nii.gz ./tensor/kurtosis.nii.gz
fi

#fslmaths md.nii.gz -mul 1000 md.nii.gz;
#fslmaths rd.nii.gz -mul 1000 rd.nii.gz;
#fslmaths ad.nii.gz -mul 1000 ad.nii.gz;

if [ -f ./tensor/fa.nii.gz ]; then
	rm -rf *.nii.gz *dwi.*
	echo "complete"
	exit 0
else
	echo "failed"
	exit 1
fi
