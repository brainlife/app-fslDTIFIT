[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/soichih/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.137-blue.svg)](https://doi.org/10.25663/bl.app.137)

# app-fslDTIFIT
This app will fit the diffusion tensor model (DTI) to a diffusion MRI image using FSL's dtifit commmand. 

### Authors
- Brad Caron (bacaron@iu.edu)
- Ilaria Sani (isani01@rockefeller.edu)

### Contributors
- Soichi Hayashi (hayashi@iu.edu)
- Franco Pestilli (franpest@indiana.edu)

### Funding
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)

## Running the App 

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/bl.app.137](https://doi.org/10.25663/bl.app.137) via the "Execute" tab.

### Running Locally (on your machine)

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
  "dwi":  "./input/dwi/dwi.nii.gz",
  "bvals":  "./input/dwi/dwi.bvals",
  "bvecs":  "./input/dwi/dwi.bvecs"
}
```

### Sample Datasets

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download 5b96bd23059cf900271924f8 && mv 5967bffa9b45c212bbec8956 input/dwi
```


3. Launch the App by executing `main`

```bash
./main
```

## Output

The main output of this App is a tensor output. This output contains the tensor files fa.nii.gz (fractional anisotropy), md.nii.gz (mean diffusivity), ad.nii.gz (axial diffusivity), and rd.nii.gz (radial diffusivity).

#### Product.json
The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing. 

### Dependencies

This App requires the following libraries when run locally.

  - singularity: https://singularity.lbl.gov/
  - FSL: https://hub.docker/com/r/brainlife/fsl/tags/5.0.9
