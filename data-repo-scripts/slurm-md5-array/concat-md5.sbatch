#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=00:10:00
#SBATCH --job-name=concat-and-check
#SBATCH --partition=short-cpu
#SBATCH --output=%x.%j.log # gives jobname.ID.log
set -euo pipefail
datetime=$(date +"%Y-%m-%d_%H:%M:%S") && echo "[$datetime] ${SLURM_JOB_NAME:=dry-run} $@" # log the command line

outfile=$1
shift

if [ -e "$outfile" ]
then
    mv $outfile ${outfile}_$(date +"%Y-%m-%d-%H-%M-%S") 
    touch $outfile
fi
    
cmd="cat *.md5 >> $outfile"
echo $cmd
time eval $cmd
