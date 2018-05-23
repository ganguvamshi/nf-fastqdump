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

    nextflow run fq_merge.nf 

    Options:
        --runfile [sra runinfo file]                Path to sra run file
        --datadir [fastq data folder path]          Directory path for fastq files [def: ./fastq]
    """.stripIndent()

}


params.help = false
params.runfile = ""
params.datadir = "./data/"
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

files = Channel.fromPath( params.runfile ).splitCsv(header:['SRR','GSM'], sep="\t").collate(2).groupTuple(by: 1)


process parse_runid {
    input:
    set gsmid, set(srr_ids) from files

    output:
    set gsmid, "${gsmid}_merged.fq" into results
    
    shell:
    """
    echo "merging replicates for ${gsmid}"
    echo gunzip -c $srr_ids ${gsmid}_merged.fq 
    """
}
