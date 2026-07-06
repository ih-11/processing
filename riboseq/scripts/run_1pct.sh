#!/usr/bin/env bash
set -euo pipefail

ROOT="$(pwd)"

nextflow run nf-core/riboseq \
  -r 1.2.0 \
  -profile apptainer \
  --input "${ROOT}/samplesheets/samplesheet_1pct.csv" \
  --outdir "${ROOT}/results/1pct" \
  --fasta "${ROOT}/refs/at.fa.gz" \
  --gtf "${ROOT}/refs/at.gtf.gz" \
  --save_reference \
  --skip_fastqc \
  --extra_trimgalore_args "--no_report_file" \
  -work-dir "${ROOT}/work/1pct" \
  "$@"
