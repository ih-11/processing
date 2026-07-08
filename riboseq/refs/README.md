# Reference Resources

This directory contains the reference files required by the preprocessing workflow.

The reference resources are divided into two categories:

1. Source reference files
2. Built reference resources

The source files are downloaded from public databases and should not be modified.

The built reference resources are generated once from the source files and reused for all preprocessing runs.

## Source reference files

The source reference files are the original genome and annotation files used to build the preprocessing references.

Typical files include:

- Genome FASTA (`*.fa`, `*.fa.gz`)
- Genome annotation (`*.gff3`, `*.gff3.gz`)
- Genome annotation (`*.gtf`, `*.gtf.gz`)
- RSEM-compatible annotation (`*.rsem.gtf`)

These files should remain unchanged after download.

## Built reference resources

The `built/` directory contains reference resources generated from the source reference files.

These resources are created once and reused for all preprocessing runs, avoiding the need to rebuild genome indices for every analysis.

A typical built reference directory contains:

- Genome FASTA
- Genome FASTA index (`.fai`)
- Chromosome size file
- RSEM-compatible annotation
- Transcriptome FASTA
- STAR genome index
- RSEM reference
- SortMeRNA index

A typical directory structure is shown below:

```text
built/
└── <reference_name>/
    ├── genome.fa
    ├── genome.gtf
    ├── genome.transcripts.fa
    ├── index/
    │   └── star/
    ├── rsem/
    └── sortmerna/
```

The preprocessing workflow expects the configuration file to point to one built reference directory through the `REF` variable.