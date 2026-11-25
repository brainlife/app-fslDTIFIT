[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-brainlife.app.292-blue.svg)](https://doi.org/10.25663/brainlife.app.292)

# FSL DTIFIT 

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Fits the diffusion tensor to a DWI with FSL dtifit, optionally on a single extracted shell and with kurtosis, WLS or SSE options, and outputs FA, MD, AD and RD maps.**

Unless multishell is true, extracts the b=0 and chosen shell with MRtrix3 dwiextract; computes a brain mask with FSL bet on the mean b0 if none is given; runs dtifit with the selected flags; and writes fa, md, ad (L1) and rd ((L2+L3)/2) maps, plus kurtosis for multi-shell kurtosis fits. Use it to obtain standard DTI maps from preprocessed DWI. Needs a preprocessed DWI containing the requested shell.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.292](https://doi.org/10.25663/brainlife.app.292)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` | yes | The path to the DWI datatype |
| `mask` | `neuro/mask` (brain, dwi) | no | The brainmask of the DWI datatype (optional). If not inputted, will be fit using FSL BET |

| Output | Datatype | Description |
|---|---|---|
| `tensor` | `neuro/tensor` | Tensor maps fa.nii.gz, md.nii.gz, ad.nii.gz and rd.nii.gz (and kurtosis.nii.gz for multi-shell kurtosis fits). |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `kurtosis` | boolean | `false` | If true, will fit tensor using the -kurt flag |
| `kurtdir` | boolean | `false` | If true, will fit tensor using the -kurtdir flag |
| `shell` | string | `1000` | The gradient (i.e. shell) to use to fit the DTI model to |
| `wls` | boolean | `false` | If true, will fit tensor using the -wls flag |
| `sse` | boolean | `false` | If true, will fit tensor using the -sse flag |
| `gradnonlin` | boolean | `false` | If true, will fit tensor using the -gradnonlin flag |
| `multishell` | boolean | `false` | If true, will fit multi-shell tensor |

Runtime: container `brainlife/mrtrix3:3.0.3`; 12 CPUs.

Please cite:
- FSL DTIFIT: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FDT/UserGuide#DTIFIT

<!-- brainlife-app:end -->

This app will fit the diffusion tensor model (DTI) to a diffusion MRI image using FSL’s dtifit commmand. This app takes in a DWI datatype and can take in a brainmask mask datatype. If not included, will generate it's own using FSL's BET function. Can also set each flag in the dtifit command, including kurtosis fitting, fitting using weighted least-squares, outputting information about sum of squares error, gradient nonlinearities, and fitting on multishell data. Will output the tensor datatype and a brainmask mask datatype. 

### Authors 

- Brad Caron (bacaron@iu.edu) 

### Contributors 

- Soichi Hayashi (hayashis@iu.edu) 

### Funding 

[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citations 

Please cite the following articles when publishing papers that used data, code or other resources created by the brainlife.io community. 

1. https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FDT/UserGuide#DTIFIT 

## Running the App 

### On Brainlife.io 

You can submit this App online at [https://doi.org/10.25663/brainlife.app.292](https://doi.org/10.25663/brainlife.app.292) via the 'Execute' tab. 

### Running Locally (on your machine) 

1. git clone this repo 

2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files. 

```json 
{
   "dwi":    "testdata/dwi/dwi.nii.gz",
   "bvals":    "testdata/dwi/dwi.bvals",
   "bvecs":    "tesdata/dwi/dwi.bvecs",
   "mask":    "testdata/mask/mask.nii.gz",
   "kurtosis":    true,
   "kurtdir":    true,
   "shell":    1000,
   "sse":    true,
   "wls":    true,
   "gradnonlin":   false,
   "multishell":    true
} 
``` 

### Sample Datasets 

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli). 

```
npm install -g brainlife 
bl login 
mkdir input 
bl dataset download 
``` 

3. Launch the App by executing 'main' 

```bash 
./main 
``` 

## Output 

The main output of this App is is a tensor datatype including all of the tensor images. 

#### Product.json 

The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing. 

### Dependencies 

This App requires the following libraries when run locally. 

- FSL: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation
- MRtrix3: https://mrtrix.readthedocs.io/en/3.0_rc3/installation/linux_install.html
- jsonlab: https://github.com/fangq/jsonlab
- singularity: https://singularity.lbl.gov/quickstart
