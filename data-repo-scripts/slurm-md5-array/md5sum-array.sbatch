#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=00:05:00
#SBATCH --job-name=md5sum-array
#SBATCH --partition=short-cpu
#SBATCH --output=%x.%A_%a.log 
set -euo pipefail
datetime=$(date +"%Y-%m-%d_%H:%M:%S") && echo "[$datetime] ${SLURM_JOB_NAME:=dry-run} $@" # log the command line

args=($@)
i=$((SLURM_ARRAY_TASK_ID - 1))
echo SLURM_ARRAY_TASK_ID=$SLURM_ARRAY_TASK_ID and i=$i
filearg=${args[$i]}
echo "filearg=$filearg"
cmd="md5sum $filearg > ${filearg}.md5"
echo $cmd
time eval $cmd
