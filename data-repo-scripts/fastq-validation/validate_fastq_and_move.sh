#!/usr/bin/env bash
# check a fastq file filename
# iterate through a fastq file until failure or EOF
# If failure, write the validated sequences to NSEQ_filename.fastq

validate_stdout=$(mktemp  --suffix=.fq)
validate_stderr=$(mktemp  --suffix=.err)

filename=$1

if python validate_fastq.py $1 > ${validate_stdout} 2> ${validate_stderr}
then
    echo "$1 validates"
    tail -n 1 $validate_stderr # "got N sequences"
    rm $validate_stdout $validate_stderr
else
    echo "$1 does not fully validate"
    nseqs_arr=($( tail -n 1 $validate_stderr ))
    nseqs=${nseqs_arr[0]}

    echo "nseqs=$nseqs"

    dest="${nseqs}_$(basename $filename .gz)" # remove .gz if it exists

    mv_cmd="mv $validate_stdout $dest"
    echo $mv_cmd
    eval $mv_cmd

    rm $validate_stderr
fi
