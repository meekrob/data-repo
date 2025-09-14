#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

// Parameters
params.indir = "input"
params.md5files = "intermediate_md5"
params.outdir = "${params.indir}"
params.help = false

process MD5 {
    tag "Running md5sum on {infile}"
    publishDir "${params.md5files}", mode: 'copy'

    input:
    path infile

    output:
    path "${infile}.md5", emit: file_md5

    script:
    """
    md5sum ${infile} > ${infile}.md5
    """
}

process CONCAT {
    tag "joining md5 files"
    publishDir "${params.outdir}", mode: 'link'

    input: 
    path md5sum_files

    output:
    path "md5.txt", emit: concat_file

    script:
    """
    cat ${md5sum_files} > md5.txt
    """
}

workflow {
    infiles_channel = Channel.fromPath("${params.indir}/*")
    
    MD5(infiles_channel)

    md5_files_channel = MD5.out.file_md5.flatten()

    CONCAT(md5_files_channel)
}

