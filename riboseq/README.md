# riboseq

A reusable and reproducible workflow for processing **Ribo-seq** and **RNA-seq** datasets using the **nf-core/riboseq** pipeline.

This repository is designed as a generic framework rather than a single-project analysis. It separates workflow execution from project-specific configuration, allowing the same pipeline to be reused across different experiments and organisms.

---

# Features

- Generic nf-core/riboseq launcher
- Configuration-based execution
- Reusable reference resources
- Compatible with multiple species
- Version-controlled workflow
- Designed for local workstations and HPC environments

---

# Repository structure

```text
riboseq/
├── configs/            # Run-specific configurations
├── data/               # Input FASTQ files (ignored by git)
├── docs/               # Documentation and notes
├── env/                # Conda environment
├── refs/
│   ├── genome/
│   │   ├── at.fa.gz
│   │   ├── at.gtf.gz
│   │   └── ...
│   └── built/          # Generated reference resources (ignored by git)
├── results/            # Pipeline outputs (ignored by git)
├── samplesheets/
├── scripts/
│   └── run.sh
└── work/               # Nextflow work directory (ignored by git)
```

---

# Design philosophy

The workflow follows three simple principles.

1. **One launcher**

Instead of maintaining multiple scripts,

```
run_1k.sh
run_1pct.sh
run_full.sh
```

the repository uses a single launcher

```
scripts/run.sh
```

2. **Configuration-driven execution**

Each analysis is controlled by a configuration file.

Example:

```
configs/debug.config
configs/1pct.config
configs/full.config
```

Only configuration changes between analyses.

3. **Reusable references**

Reference resources are generated once and reused across all analyses for the same organism.

This minimizes runtime while ensuring reproducibility.

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

Additional Nextflow arguments can be passed directly.

Examples

```bash
bash scripts/run.sh configs/full.config -resume
```

```bash
bash scripts/run.sh configs/full.config -stub-run
```

---

# Reference preparation

Reference preparation is performed **once per organism**.

The generated resources include

- STAR genome index
- SortMeRNA index
- transcriptome FASTA
- RSEM reference

These resources are stored under

```
refs/built/<species_name>/
```

For example

```
refs/built/
├── arabidopsis_tair10/
├── saccharomyces_r64/
├── chlamydomonas_cc4532/
├── rice_irgsp1/
└── human_grch38/
```

Once generated, these references can be reused indefinitely for every dataset from the same genome assembly.

Only the FASTQ files and samplesheet change between experiments.

---

# Processing a new species

When processing a species for the first time:

1. Download the genome FASTA.
2. Download the genome annotation (GTF or GFF3).
3. Ensure the annotation is compatible with RSEM.
4. Run a small debug dataset (for example 1K reads).
5. Generate the reference resources.
6. Store the generated references under

```
refs/built/<species_name>/
```

Future analyses for that species should reuse the existing references instead of rebuilding them.

---

# Annotation compatibility

Some annotations may not be fully compatible with downstream tools.

For example, during development the Araport11 annotation contained records without a `gene_id` attribute, causing RSEM reference generation to fail.

The solution was to create a cleaned annotation by removing records lacking `gene_id`.

```bash
zcat refs/at.gtf.gz \
| awk '$0 ~ /gene_id/' \
| gzip > refs/at.rsem.gtf.gz
```

This type of preprocessing is only required when the original annotation is incompatible with downstream software.

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

# Git policy

The repository contains workflow code only.

Tracked

- scripts
- configs
- documentation
- samplesheets
- environment specification

Ignored

- FASTQ files
- pipeline outputs
- Nextflow work directory
- generated reference resources
- Apptainer images

This keeps the repository lightweight while maintaining complete reproducibility.

---

# Current example

The current implementation has been validated using

| Item | Value |
|------|------|
| Species | *Arabidopsis thaliana* |
| BioProject | PRJNA990964 |
| Ribo-seq | SRR25120039 |
| RNA-seq | SRR25120043 |
| Pipeline | nf-core/riboseq v1.2.0 |

This dataset serves as an example implementation. The workflow itself is intended to be reusable for any organism with appropriate reference resources.