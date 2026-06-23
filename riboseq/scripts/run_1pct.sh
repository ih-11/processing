#!/usr/bin/env bash
set -euo pipefail

nextflow run nf-core/riboseq \
  -r 1.2.0 \
  -profile apptainer \
  --input samplesheets/samplesheet_1pct.csv \
  --outdir results/1pct \
  --fasta refs/at.fa.gz \
  --gff refs/at.gff3.gz \
  -work-dir work/1pct
