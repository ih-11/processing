# Post-processing Framework

This directory contains the post-processing framework for converting **nf-core/riboseq** outputs into standardized analysis-ready tables.

The nf-core/riboseq pipeline performs preprocessing, quality control, alignment, quantification, and ORF prediction. These results are distributed across multiple directories and file formats. The purpose of this framework is to integrate those outputs into reusable tabular datasets suitable for downstream analyses.

Unlike the main workflow, which focuses on reproducible execution of the nf-core pipeline, this framework focuses on data exploration, validation, table generation, and biological interpretation.

---

# Objectives

The post-processing framework aims to:

- Parse nf-core/riboseq outputs into standardized tables.
- Provide interactive notebooks for quality inspection and exploratory analysis.
- Generate reusable intermediate datasets.
- Separate preprocessing from downstream biological analyses.
- Support multiple organisms using the same analytical workflow.

---

# Design philosophy

The framework follows five guiding principles.

## 1. Modular analysis

Each notebook performs a single analytical task.

Rather than generating one large output directly, every processing stage produces a logically independent intermediate table.

Examples include:

- transcript annotation
- RNA-seq quantification
- Ribo-seq quantification
- translation efficiency
- alignment summaries
- footprint summaries

This modular design makes each processing stage easier to validate, maintain, and reuse.

---

## 2. Notebook-driven workflow

Each analytical step is implemented as an independent Jupyter notebook.

This enables interactive inspection of intermediate results, rapid visualization, exploratory analyses, and transparent documentation of every processing step.

---

## 3. Species-specific implementations

Although the analytical workflow remains largely identical across organisms, each species may require different reference annotations, transcript identifiers, or organism-specific preprocessing.

Each species therefore maintains its own notebook collection.

Example directory structure:

```text
postprocess/
├── README.md
├── arabidopsis_thaliana/
├── saccharomyces_cerevisiae/
├── chlamydomonas_reinhardtii/
└── ...
```

Each species directory contains notebooks implementing the same analytical workflow while operating on species-specific datasets.

---

## 4. Standardized outputs

The objective is to generate standardized tabular datasets rather than organism-specific reports.

Typical outputs include:

- annotation table
- RNA quantification table
- Ribo-seq quantification table
- translation efficiency table
- alignment summary table
- P-site summary table
- master analysis table

These standardized tables become the primary input for downstream visualization, statistical analyses, and machine learning.

---

## 5. Lightweight repository

Large sequencing datasets, alignment files, reference indices, and generated tables are intentionally stored outside the Git repository.

Only notebooks, documentation, and workflow code are version controlled.

This keeps the repository lightweight while maintaining complete reproducibility.

---

# Typical workflow

```text
FASTQ
   │
   ▼
nf-core/riboseq
   │
   ▼
Pipeline outputs
   │
   ▼
Post-processing notebooks
   │
   ├── Annotation
   ├── Quantification
   ├── Translation efficiency
   ├── Alignment summaries
   ├── Footprint summaries
   └── Table integration
   │
   ▼
Standardized analysis tables
   │
   ▼
Downstream biological analyses
```

---

# Species directory structure

Each organism follows the same notebook organization.

```text
species/
├── 01_annotation.ipynb
├── 02_salmon.ipynb
├── 03_te.ipynb
├── 04_bam.ipynb
├── 05_ribowaltz.ipynb
└── 06_merge.ipynb
```

| Notebook | Purpose |
|-----------|---------|
| `01_annotation.ipynb` | Build transcript and gene annotation tables from the reference annotation. |
| `02_salmon.ipynb` | Parse RNA-seq and Ribo-seq Salmon quantification results. |
| `03_te.ipynb` | Calculate translation efficiency and related summary statistics. |
| `04_bam.ipynb` | Inspect BAM alignments and summarize alignment-derived metrics. |
| `05_ribowaltz.ipynb` | Parse RiboWaltz outputs including P-site offsets and footprint statistics. |
| `06_merge.ipynb` | Merge validated intermediate tables into a master analysis table. |

---

# Expected outputs

The framework is designed to generate reusable intermediate tables.

Typical outputs include:

- `annotation.tsv`
- `rna_quant.tsv`
- `ribo_quant.tsv`
- `translation_efficiency.tsv`
- `alignment_summary.tsv`
- `psite_summary.tsv`
- `master.tsv`

Each table represents one analytical stage and can be regenerated independently without repeating the entire workflow.

---

# Environment

The notebooks should be executed using the same Conda environment used for the nf-core/riboseq workflow.

The environment should include Jupyter support together with common scientific Python libraries, including:

- ipykernel
- Jupyter
- NumPy
- pandas
- matplotlib

Additional libraries may be installed as future analyses require.

---

# Scope

This framework is intended for:

- post-processing
- exploratory data analysis
- quality assessment
- standardized table generation

Publication-quality figures, statistical analyses, and manuscript-specific visualizations should generally be developed separately from this framework to preserve its reusability across multiple projects.