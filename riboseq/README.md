# riboseq

A reusable, reproducible, and configuration-driven workflow for processing **Ribo-seq** and matched **RNA-seq** datasets using the **nf-core/riboseq** pipeline.

Rather than representing a single analysis, this repository provides a reusable framework for running ribosome profiling workflows across multiple organisms, projects, and computing environments. Workflow execution is separated from project-specific configuration, allowing the same analysis pipeline to be reused simply by changing configuration files, reference resources, and sample metadata.

The long-term objective of this repository is not only to execute the nf-core/riboseq pipeline, but also to document and understand every computational step so that each stage can be confidently explained, reproduced, and described in the Methods section of a scientific publication.

---

# Features

- Reusable **nf-core/riboseq** launcher
- Configuration-driven workflow execution
- Reusable reference resources
- Support for multiple species and genome assemblies
- Local workstation and HPC compatible
- Version-controlled workflow
- Comprehensive documentation of pipeline logic
- Designed for reproducible research

---

# Repository structure

```text
riboseq/
├── benchmark/          # Benchmark configurations and validation logs
├── configs/            # Run-specific configurations
├── data/               # Development and benchmark FASTQ files
├── docs/               # Documentation
├── env/                # Conda environment
├── refs/               # Reference genomes and annotations
├── results/            # Pipeline outputs (git ignored)
├── samplesheets/       # nf-core samplesheets
├── scripts/
│   └── run.sh          # Generic launcher
└── work/               # Nextflow working directory (git ignored)
```

---

# Design philosophy

The repository follows three guiding principles.

## 1. One launcher

The workflow is executed using a single launcher.

```bash
scripts/run.sh
```

Instead of maintaining multiple execution scripts

```text
run_debug.sh
run_1pct.sh
run_full.sh
```

only the configuration changes while the launcher remains identical.

---

## 2. Configuration-driven execution

Each analysis is defined by a configuration file.

Examples

```text
configs/debug.config
configs/1pct.config
configs/full.config
```

Different projects therefore require only a new configuration rather than modifications to the workflow.

---

## 3. Reusable reference resources

Reference resources are generated once for each genome assembly.

These include, for example,

- STAR genome index
- SortMeRNA database
- Transcriptome FASTA
- RSEM reference

Once generated, these resources can be reused for every dataset using the same genome assembly, substantially reducing preprocessing time while maintaining reproducibility.

---

# Workflow overview

```text
FASTQ
   │
   ▼
FASTP
   │
   ▼
SortMeRNA
   │
   ▼
STAR
   │
   ├── Genome alignment
   └── Transcriptome alignment
            │
            ▼
Salmon
            │
            ▼
Downstream analyses
    ├── RiboTISH
    ├── RiboWaltz
    ├── RiboTricer
    └── MultiQC
```

A detailed explanation of every processing step is provided in

```
docs/01_pipeline.md
```

---

# Installation

Create the Conda environment

```bash
conda env create -f env/environment.yml
```

Activate

```bash
conda activate nf-ribo
```

The workflow requires

- Nextflow
- Java
- Apptainer (or another supported container runtime)
- nf-core tools

---

# Running the workflow

## Debug dataset

```bash
bash scripts/run.sh configs/debug.config
```

## Validation dataset

```bash
bash scripts/run.sh configs/1pct.config
```

## Production dataset

```bash
bash scripts/run.sh configs/full.config
```

Additional Nextflow options may be supplied directly.

Examples

```bash
bash scripts/run.sh configs/full.config -resume
```

```bash
bash scripts/run.sh configs/full.config -stub-run
```

---

# Reference preparation

Reference resources are generated once for each genome assembly.

Typical generated resources include

- STAR genome index
- SortMeRNA database
- Transcriptome FASTA
- RSEM reference

During development these resources may be stored inside this repository.

For production analyses they are typically stored on external storage or HPC filesystems and referenced by configuration files.

Reference preparation is described in detail in

```
docs/02_reference_preparation.md
```

---

# Processing a new species

Processing a new organism typically involves

1. Downloading the genome FASTA
2. Downloading the genome annotation
3. Validating annotation compatibility
4. Generating reference resources
5. Running a small benchmark dataset
6. Running the full dataset

Only the sequencing data and configuration files change between projects.

---

# Documentation

Detailed documentation is maintained separately from the repository overview.

| Document | Description |
|----------|-------------|
| `docs/01_pipeline.md` | Complete pipeline walkthrough |
| `docs/02_reference_preparation.md` | Reference generation |
| `docs/03_arabidopsis_PRJNA990964.md` | Arabidopsis benchmark dataset |
| `docs/04_benchmark.md` | Validation history |
| `docs/05_troubleshooting.md` | Development notes and debugging |
| `docs/06_repository_design.md` | Repository philosophy |
| `docs/07_future_work.md` | Planned improvements |

---

# Data management

Large sequencing datasets, generated references, pipeline outputs, and intermediate files are intentionally excluded from version control.

Typical storage locations include

- local storage
- external drives
- laboratory servers
- HPC project directories
- HPC scratch space

Only workflow code, documentation, configurations, and reproducibility metadata are tracked by Git.

---

# Git policy

Tracked

- scripts
- configuration files
- documentation
- samplesheets
- environment specification

Ignored

- sequencing data
- generated references
- pipeline outputs
- Nextflow work directories
- Apptainer cache

This keeps the repository lightweight while maintaining complete reproducibility.

---

# Current validation status

Current validation has been performed using

| Item | Value |
|------|------|
| Species | *Arabidopsis thaliana* |
| BioProject | PRJNA990964 |
| Tissue | Shoot |
| RNA-seq | SRR25120043 |
| Ribo-seq | SRR25120039 |
| Pipeline | nf-core/riboseq v1.2.0 |

Additional benchmark information is documented in

```
docs/04_benchmark.md
```

---

# License

This repository is released under the MIT License.

---

# Citation

If this repository contributes to published work, please also cite

- nf-core/riboseq
- Nextflow
- the original biological dataset used in the analysis