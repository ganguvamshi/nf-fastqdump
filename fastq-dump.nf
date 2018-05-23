#!/usr/bin/env nextflow

/*
==============================================================
FASTQ DUMP 
==============================================================
https://github.com/ganguvamshi/nf-fastqdump

@##### Authors
Vamshidhar Gangu <ganguvamshi@gmail.com>
---------------------------------------------------------

Pipeline overview:

fastq-dump : converts the downloaded sra files into fastq files

*/

def helpMessage() {
    log.info"""
    ===============================================
    ganguvamshi/nf-fastqdump : fastq-dump module 
    ===============================================

    Usage:

    The typical commang for running the pipeline is as below:

    nextflow run ganguvamshi/nf-fastqdump --srafiles '*.sra' 

    Options:
        --gzip false                        for uncompressed fastq files
        --output [output dir path]          Directory path for output [def: ./fqdump_results]
    """.stripIndent()

}


params.help = false
if(params.help){
    helpMessage()
    exit 0
}

params.output = 'fqdump_results/'
params.srafiles = ""


log.info "F A S T Q - D U M P -- N F ~ version 0.1"
log.info "========================================="
log.info "name                  :${params.name}"
log.info "output                :${params.output}"
log.info "\n"

files = Channel.fromPath( params.srafiles )


process sra_to_fq {
    input:
    file 'srainp' from files

    output:
    stdout into results
    
    script:
    if(params.gzip)

    """   
    fastq-dump --gzip --split-3 --output ${params.output} ${file}
    echo ${file}
    """
    else

    """
    
    fastq-dump --split-3 --output ${params.output} ${file}
    echo ${file}
    """
}

workflow.onComplete{
    println "fastq-dump pipleine is completed at $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}