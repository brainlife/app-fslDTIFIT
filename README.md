<h1 align="center">FSL DTIFIT</h1>

<p align="center">
  FA, MD, AD and RD maps (and optionally kurtosis) from a diffusion-weighted image, fitted with FSL <code>dtifit</code>.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.292"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.292-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

This App fits the diffusion tensor model (DTI) to a diffusion MRI image with FSL's [`dtifit`](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FDT/UserGuide#DTIFIT). It takes a DWI dataset and, optionally, a brain mask; without a mask it computes one with FSL BET. Every `dtifit` option is exposed: kurtosis fitting, weighted least squares, sum-of-squares error output, gradient non-linearities and multi-shell fitting.

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Fits the diffusion tensor to a DWI with FSL dtifit, optionally on a single extracted shell and with kurtosis, WLS or SSE options, and outputs FA, MD, AD and RD maps.**

Unless multishell is true, extracts the b=0 and chosen shell with MRtrix3 dwiextract; computes a brain mask with FSL bet on the mean b0 if none is given; runs dtifit with the selected flags; and writes fa, md, ad (L1) and rd ((L2+L3)/2) maps, plus kurtosis for multi-shell kurtosis fits. Use it to obtain standard DTI maps from preprocessed DWI. Needs a preprocessed DWI containing the requested shell.

| | |
|---|---|
| 📥 **Inputs** | `neuro/dwi` · `neuro/mask` (optional) |
| 📤 **Outputs** | `neuro/tensor` |
| 🐳 **Container** | `brainlife/mrtrix3:3.0.3` |
| ⚙️ **Resources** | 12 CPUs |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.292](https://doi.org/10.25663/brainlife.app.292) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` | yes | The path to the DWI datatype |
| `mask` | `neuro/mask` (brain, dwi) | no | The brainmask of the DWI datatype (optional). If not inputted, will be fit using FSL BET |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `tensor` | `neuro/tensor` | Tensor maps fa.nii.gz, md.nii.gz, ad.nii.gz and rd.nii.gz (and kurtosis.nii.gz for multi-shell kurtosis fits). |

<details>
<summary><b>⚙️ Parameters</b> (7)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `kurtosis` | boolean | `false` | If true, will fit tensor using the -kurt flag |
| `kurtdir` | boolean | `false` | If true, will fit tensor using the -kurtdir flag |
| `shell` | string | `1000` | The gradient (i.e. shell) to use to fit the DTI model to |
| `wls` | boolean | `false` | If true, will fit tensor using the -wls flag |
| `sse` | boolean | `false` | If true, will fit tensor using the -sse flag |
| `gradnonlin` | boolean | `false` | If true, will fit tensor using the -gradnonlin flag |
| `multishell` | boolean | `false` | If true, will fit multi-shell tensor |

</details>

<!-- brainlife-app:end -->

## 🏷️ Versions on brainlife.io

Each version is a separate App on brainlife.io, built from its own branch of this repository.

| Version | FSL | Branch | Run it | Status |
|---|---|---|---|---|
| FSL DTIFIT | 5.0.11 | [`v1.1`](https://github.com/brainlife/app-fslDTIFIT/tree/v1.1) | [doi:10.25663/brainlife.app.292](https://doi.org/10.25663/brainlife.app.292) | current |
| FSL DTIFIT - OLD | 5.0.9 | [`1.0`](https://github.com/brainlife/app-fslDTIFIT/tree/1.0) | [doi:10.25663/brainlife.app.137](https://doi.org/10.25663/brainlife.app.137) | deprecated |

## 🚀 Running the App

### ☁️ On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.292](https://doi.org/10.25663/brainlife.app.292), choose a preprocessed DWI dataset (and optionally a DWI brain mask) from your project, set the options and press **Execute**. The App archives a `neuro/tensor` dataset (tag `fsl`) to your project.

| Parameter | Default | Meaning |
|---|---|---|
| `shell` | `1000` | b-value of the shell to fit; the b=0 volumes and this shell are extracted with MRtrix3 `dwiextract` |
| `multishell` | `false` | fit all shells instead of extracting one; required for `kurtosis` and `kurtdir` |
| `kurtosis` | `false` | `dtifit --kurt` (multi-shell only) |
| `kurtdir` | `false` | `dtifit --kurtdir` (multi-shell only) |
| `wls` | `false` | fit with weighted least squares (`--wls`) |
| `sse` | `false` | output the sum of squared errors (`--sse`) |
| `gradnonlin` | `false` | correct for gradient non-linearities (`--gradnonlin`) |

### 💻 Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). `main` uses the `brainlife/mrtrix3:3.0.3` and `brainlife/fsl:5.0.11` containers.

1. Clone this repository and check out the registered version (`git checkout v1.1`).
2. Create `config.json` with the paths to your inputs and the options you want. Set `mask` to `null` (or leave it out) to compute the mask with BET:

   ```json
   {
       "dwi": "input/dwi/dwi.nii.gz",
       "bvals": "input/dwi/dwi.bvals",
       "bvecs": "input/dwi/dwi.bvecs",
       "mask": "input/mask/mask.nii.gz",
       "shell": 1000,
       "multishell": false,
       "kurtosis": false,
       "kurtdir": false,
       "sse": false,
       "wls": false,
       "gradnonlin": false
   }
   ```

3. Run the App:

   ```bash
   ./main
   ```

Without containers you need [FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation) and [MRtrix3](https://www.mrtrix.org/) on your path.

## 📦 Outputs

```text
tensor/
├── fa.nii.gz          fractional anisotropy
├── md.nii.gz          mean diffusivity
├── ad.nii.gz          axial diffusivity (L1)
├── rd.nii.gz          radial diffusivity ((L2 + L3) / 2)
└── kurtosis.nii.gz    mean kurtosis (only with multishell and kurtosis)
```

## 🩺 Troubleshooting

- **`output missing`**: `dtifit` did not produce `fa.nii.gz`. Check that the requested `shell` exists in the bvals and that the bvecs and bvals match the DWI.
- **Kurtosis maps are missing**: `kurtosis` and `kurtdir` take effect only when `multishell` is true.

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- FSL DTIFIT. brainlife.io App. [doi:10.25663/brainlife.app.292](https://doi.org/10.25663/brainlife.app.292)
- FSL DTIFIT: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FDT/UserGuide#DTIFIT
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Tournier et al. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. *NeuroImage* 202:116137 (2019). [doi:10.1016/j.neuroimage.2019.116137](https://doi.org/10.1016/j.neuroimage.2019.116137)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## 👥 Authors

- Brad Caron

**Contributors:** Soichi Hayashi, Anibal Sólon

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## ⚖️ License

[MIT](LICENSE). FSL is distributed under its own [license](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence).
