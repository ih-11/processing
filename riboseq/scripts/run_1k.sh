#!/usr/bin/env bash
set -euo pipefail

ROOT="$(pwd)"

nextflow run nf-core/riboseq \
  -r 1.2.0 \
  -profile apptainer \
  --input "${ROOT}/samplesheets/samplesheet_1k.csv" \
  --outdir "${ROOT}/results/1k" \
  --fasta "${ROOT}/refs/at.fa.gz" \
  --gtf "${ROOT}/refs/at.gtf.gz" \
  --save_reference \
  --skip_fastqc \
  -work-dir "${ROOT}/work/1k" \
  "$@"
