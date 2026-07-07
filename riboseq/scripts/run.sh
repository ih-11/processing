#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="${1:?Usage: bash scripts/run.sh configs/debug.config}"

source "${ROOT}/${CONFIG}"

REF="${ROOT}/refs/built/arabidopsis_tair10_rsemclean"

nextflow run nf-core/riboseq \
  -r 1.2.0 \
  -profile apptainer \
  --input "${ROOT}/${INPUT}" \
  --outdir "${OUTDIR}" \
  --fasta "${REF}/at.fa" \
  --gtf "${REF}/at.rsem.gtf" \
  --transcript_fasta "${REF}/genome.transcripts.fa" \
  --star_index "${REF}/index/star" \
  --skip_fastqc \
  --trimmer fastp \
  -work-dir "${WORKDIR}" \
  "${@:2}"
