#!/usr/bin/env bash
set -euo pipefail
outfile=pacBio_Cxt.filelist.md5
nfiles=$(grep -v Filename pacBio_Cxt.filelist.txt | wc -l)
filelist=$(grep -v Filename pacBio_Cxt.filelist.txt | cut -f 1)
main_jid=$(sbatch --parsable --array=1-$nfiles scripts/slurm-md5-array/md5sum-array.sbatch $filelist)
sbatch --dependency=afterok:$main_jid scripts/slurm-md5-array/concat-md5.sbatch $outfile
