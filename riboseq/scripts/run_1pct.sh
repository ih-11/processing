#!/usr/bin/env bash
set -euo pipefail

nextflow run nf-core/riboseq \
  -r 1.2.0 \
  -profile apptainer \
  --input samplesheets/samplesheet_1pct.csv \
  --outdir results/1pct \
  --fasta refs/at.fa.gz \
  --gtf refs/at.gtf.gz \
  --save_reference \
  -work-dir work/1pct \
  "$@"
