# riboseq

A reusable and reproducible workflow for processing **Ribo-seq** and **RNA-seq** datasets using the **nf-core/riboseq** pipeline.

This repository is intended to serve as a reusable framework rather than a single-project analysis. It separates workflow execution from project-specific configuration so that the same workflow can be applied to different experiments, organisms, and computing environments.

---

# Features

- Generic nf-core/riboseq launcher
- Configuration-driven execution
- Reusable reference resources
- Compatible with multiple species
- Version-controlled workflow
- Suitable for local workstations and HPC environments

---

# Repository structure

```text
riboseq/
├── configs/            # Run-specific configurations
├── data/               # Input FASTQ files (development/debug)
├── docs/               # Documentation and notes
├── env/                # Conda environment
├── refs/               # Reference genomes and annotations
├── results/            # Pipeline outputs (ignored by git)
├── samplesheets/       # nf-core input samplesheets
├── scripts/
│   └── run.sh          # Generic launcher
└── work/               # Nextflow working directory (ignored by git)
```

---

# Design philosophy

The workflow follows three simple principles.

## 1. One launcher

Instead of maintaining multiple execution scripts,

```
run_1k.sh
run_1pct.sh
run_full.sh
```

the repository uses a single launcher

```
scripts/run.sh
```

The workflow itself never changes.

---

## 2. Configuration-driven execution

Each analysis is controlled by a configuration file.

Examples

```
configs/debug.config
configs/1pct.config
configs/full.config
```

Changing datasets should only require changing the configuration.

---

## 3. Reusable reference resources

Reference resources are generated once for each genome assembly and reused for all subsequent analyses.

This minimizes runtime while maintaining identical analytical results.

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

Additional Nextflow options may be appended.

Examples

```bash
bash scripts/run.sh configs/full.config -resume
```

```bash
bash scripts/run.sh configs/full.config -stub-run
```

---

# Reference preparation

Reference resources are generated **once per genome assembly**.

Typical generated resources include

- STAR genome index
- SortMeRNA index
- transcriptome FASTA
- RSEM reference

During workflow development these resources may be stored inside this repository (for example under `refs/built/`).

For production analyses, these resources are typically stored on external storage (e.g. `/mnt/d`, `/mnt/f`, shared lab storage, or HPC storage) and referenced through the workflow configuration.

Once generated, the same references can be reused indefinitely for all datasets using the same genome assembly.

Only the sequencing data and samplesheet change between experiments.

---

# Processing a new species

When processing a species (or genome assembly) for the first time:

1. Download the reference genome (FASTA).
2. Download the corresponding genome annotation (GTF or GFF3).
3. Verify that the annotation is compatible with downstream tools.
4. Run a small validation dataset (for example, 1K reads).
5. Generate the required reference resources (e.g. STAR index, SortMeRNA index, transcriptome FASTA, and RSEM reference).
6. Store the generated reference resources in a permanent location suitable for your computing environment.

Once generated, these reference resources can be reused for every dataset originating from the same genome assembly. Only the sequencing reads and project-specific configuration need to change between analyses.

If a different genome assembly is used (for example TAIR10 vs TAIR11, or GRCh37 vs GRCh38), a separate set of reference resources should be generated.

---

# Annotation compatibility

Some genome annotations require preprocessing before they can be used by downstream software.

For example, during development the Araport11 annotation contained records lacking the `gene_id` attribute, causing RSEM reference generation to fail.

The cleaned annotation was generated using

```bash
zcat refs/at.gtf.gz \
| awk '$0 ~ /gene_id/' \
| gzip > refs/at.rsem.gtf.gz
```

This preprocessing was performed solely to satisfy software requirements and does not alter the analytical workflow.

---

# Workflow

```
FASTQ
   │
   ▼
fastp
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
    ├── RiboTish
    ├── RiboWaltz
    ├── RiboTricer
    └── MultiQC
```

---

# Data management

This repository contains the workflow, configuration files, and documentation required to reproduce Ribo-seq analyses.

Large sequencing datasets, generated reference resources, intermediate files, and pipeline outputs are intentionally excluded from version control.

Users are encouraged to store these resources in locations appropriate for their computing environment, for example:

- local storage
- external drives
- laboratory shared storage
- HPC scratch space
- HPC project directories

The workflow does **not** require a specific directory layout. Input data, reference resources, output directories, and working directories can be placed anywhere on the system, provided the paths are correctly specified in the workflow configuration.

The directories included in this repository (e.g. `data/`, `refs/`, `results/`, and `work/`) are primarily intended for workflow development, debugging, and validation. Production analyses may use completely different storage locations without modifying the workflow itself.

---

# Git policy

Tracked

- scripts
- configs
- documentation
- samplesheets
- environment specification

Ignored

- sequencing data
- pipeline outputs
- Nextflow work directory
- generated reference resources
- Apptainer images

This keeps the repository lightweight while ensuring reproducibility.

---

# Current example

The workflow has currently been validated using the following example dataset.

| Item | Value |
|------|------|
| Species | *Arabidopsis thaliana* |
| BioProject | PRJNA990964 |
| Ribo-seq | SRR25120039 |
| RNA-seq | SRR25120043 |
| Pipeline | nf-core/riboseq v1.2.0 |

This dataset serves only as a validation example. The workflow itself is intended to be reusable for any organism provided that appropriate reference resources have been prepared.