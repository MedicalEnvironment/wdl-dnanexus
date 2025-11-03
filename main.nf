#!/usr/bin/env nextflow

/*
 * FastQC Pipeline - Nextflow Implementation
 * Converted from WDL workflow
 * 
 * This pipeline runs FastQC quality control analysis on FASTQ files
 */

nextflow.enable.dsl = 2

// Display pipeline information
log.info """\
    ========================================
    F A S T Q C   P I P E L I N E
    ========================================
    Input files    : ${params.fastq_files}
    Output dir     : ${params.outdir}
    Publish mode   : ${params.publish_mode}
    ========================================
    """
    .stripIndent()

/*
 * Process: Run FastQC on each FASTQ file
 * Equivalent to the runFastQC task in WDL
 */
process runFastQC {
    tag "${fastq_file.simpleName}"
    publishDir "${params.outdir}/fastqc_results", mode: params.publish_mode
    
    input:
    path fastq_file
    
    output:
    path "*_fastqc.zip", emit: zip
    path "*_fastqc.html", emit: html
    
    script:
    """
    fastqc --outdir . ${fastq_file}
    """
}

/*
 * Main workflow
 * Equivalent to fastqc_subworkflow in WDL
 */
workflow {
    // Create channel from input files
    // This handles the Array[File] from WDL and the scatter operation
    fastq_ch = Channel
        .fromPath(params.fastq_files, checkIfExists: true)
        .ifEmpty { error "Cannot find any FASTQ files matching: ${params.fastq_files}" }
    
    // Display found files
    fastq_ch.view { "Found FASTQ file: $it" }
    
    // Run FastQC on all files (parallel execution like WDL scatter)
    runFastQC(fastq_ch)
    
    // Collect all outputs (equivalent to WDL workflow outputs)
    runFastQC.out.zip.collect().view { "ZIP outputs: $it" }
    runFastQC.out.html.collect().view { "HTML outputs: $it" }
}

/*
 * Workflow completion notification
 */
workflow.onComplete {
    log.info """\
        ========================================
        Pipeline completed at: ${workflow.complete}
        Execution status: ${workflow.success ? 'SUCCESS' : 'FAILED'}
        Duration: ${workflow.duration}
        ========================================
        """
        .stripIndent()
}

workflow.onError {
    log.error "Oops... Pipeline execution stopped with the following message: ${workflow.errorMessage}"
}
