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
2. Download the genome annotation (GTF or GFF3).
3. Verify that the annotation is compatible with downstream tools.
4. Run a small validation dataset (for example 1K reads).
5. Generate the required reference resources.
6. Store those resources in a permanent location for future reuse.

Future analyses should reuse the existing references rather than rebuilding them.

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

This repository primarily stores

- workflow code
- configuration files
- documentation

Large sequencing datasets, intermediate files, generated reference resources, and pipeline outputs are intentionally excluded from version control.

During workflow development, small example datasets may be stored locally for debugging.

Production datasets are expected to reside on dedicated storage (local disks, external drives, or HPC storage), while this repository provides the workflow required to reproduce those analyses.

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