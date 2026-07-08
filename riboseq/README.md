# riboseq

A reusable, reproducible, and configuration-driven workflow for preprocessing **Ribo-seq** and matched **RNA-seq** datasets using the **nf-core/riboseq** pipeline.

This repository is designed as a reusable framework rather than a project-specific analysis. It separates reference preparation, pipeline execution, and downstream postprocessing into independent, reproducible components that can be reused across organisms, projects, and computing environments.

The workflow currently consists of three major stages:

1. Reference preparation
2. Upstream preprocessing with **nf-core/riboseq**
3. Downstream postprocessing into transcript-level analysis tables

The long-term goal of this repository is not only to execute the nf-core/riboseq pipeline, but also to understand, document, and reproduce every computational step so that the entire workflow can be confidently described in scientific publications.

---

# Workflow overview

```text
Reference resources
        │
        ▼
scripts/build_reference.sh
        │
        ▼
nf-core/riboseq
        │
        ▼
Pipeline outputs
(MultiQC, BAM, Salmon, ORF prediction, QC)
        │
        ▼
postprocess/
        │
        ▼
Transcript-level master table
```

---

# Repository structure

```text
riboseq/
├── configs/          # Example workflow configurations
├── data/             # Small datasets for workflow validation
├── docs/             # Additional documentation
├── env/              # Conda environment
├── postprocess/      # Downstream analysis notebooks
├── refs/             # Reference genomes and annotations
├── samplesheets/     # nf-core sample sheets
└── scripts/
    ├── build_reference.sh
    └── run.sh
```

---

# Repository philosophy

The workflow follows four design principles.

## 1. Configuration-driven execution

The execution logic never changes.

Only the configuration changes between projects.

Typical configuration variables include

- INPUT
- REF
- OUTDIR
- WORKDIR

This allows the same workflow to be reused across different datasets without modifying the execution scripts.

---

## 2. Reusable reference resources

Reference resources are generated once for a genome assembly and reused for all subsequent analyses.

Typical generated resources include

- STAR genome index
- Transcriptome FASTA
- RSEM reference
- SortMeRNA index

The workflow only requires the configuration file to specify the reference directory.

---

## 3. Species-independent workflow

The repository is not restricted to Arabidopsis.

Any organism can be processed by preparing an appropriate reference directory and updating the configuration file.

---

## 4. Reproducible downstream processing

The upstream pipeline generates standardized outputs that are subsequently processed using Jupyter notebooks.

Current downstream notebooks include

- Annotation extraction
- Salmon quantification
- Translation efficiency calculation
- BAM inspection
- RiboWaltz analysis
- Transcript-level table generation

---

# Requirements

The workflow requires

- Conda
- Nextflow
- Java
- Apptainer (or another supported container runtime)

---

# Installation

Create the Conda environment

```bash
conda env create -f env/environment.yml
```

Activate the environment

```bash
conda activate nf-ribo
```

---

# Workflow

## Step 1 — Prepare reference resources

Reference resources consist of the original genome files together with reusable indices required by nf-core/riboseq.

See

```
refs/README.md
```

for details.

---

## Step 2 — Prepare a samplesheet

Create an nf-core-compatible samplesheet describing the Ribo-seq and matched RNA-seq libraries.

Example samplesheets are provided in

```
samplesheets/
```

---

## Step 3 — Configure the workflow

Copy an example configuration and modify the required variables.

```text
INPUT
REF
OUTDIR
WORKDIR
```

The workflow itself does not need to be modified.

---

## Step 4 — Execute nf-core/riboseq

Example

```bash
bash scripts/run.sh configs/full.example.config
```

Additional Nextflow options can be supplied directly.

For example

```bash
bash scripts/run.sh configs/full.example.config -resume
```

or

```bash
bash scripts/run.sh configs/full.example.config -stub-run
```

---

## Step 5 — Inspect pipeline outputs

The nf-core workflow produces, among others,

- Quality control reports
- MultiQC summary
- Genome alignments
- Transcriptome alignments
- Salmon quantification
- ORF prediction
- RiboWaltz analysis

These outputs serve as the input for downstream analysis.

---

## Step 6 — Run downstream postprocessing

The `postprocess/` notebooks convert the nf-core outputs into standardized transcript-level tables suitable for downstream visualization and analysis.

Current notebooks include

```text
01_annotation.ipynb
02_salmon.ipynb
03_te.ipynb
04_bam.ipynb
05_ribowaltz.ipynb
06_merge.ipynb
```

The final output is a transcript-level master table that integrates annotation, quantification, and translation efficiency measurements.

---

# Validation

The workflow has been validated using the following dataset.

| Item | Value |
|------|------|
| Species | *Arabidopsis thaliana* |
| BioProject | PRJNA990964 |
| RNA-seq | SRR25120043 |
| Ribo-seq | SRR25120039 |
| Pipeline | nf-core/riboseq v1.2.0 |

The repository is designed so that the same workflow can be applied to additional organisms by updating the reference resources and configuration.

---

# License

Released under the MIT License.

---

# Acknowledgements

This workflow builds upon the excellent work of

- nf-core/riboseq
- Nextflow
- The nf-core community

Please cite the original software and the biological datasets used in your analyses where appropriate.