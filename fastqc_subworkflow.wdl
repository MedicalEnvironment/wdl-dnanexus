# WDL script for performing QC on FastQ files using FastQC on DNAnexus
version 1.0
# Script version v.0.2
# License: This project is licensed under the MIT License

workflow fastqc_subworkflow {
    # Input parameters
    input {
        # Array of FASTQ files to analyze (passed as DNAnexus input files)
        Array[File] fastqFiles
        # The directory where the output will be stored (this will be a DNAnexus output folder)
        String outputDir
    }

    # Scatter operation to run FastQC on each FASTQ file in parallel
    scatter(file in fastqFiles) {
        # Call the task to run FastQC on each FASTQ file
        call runFastQC {
            input:
                fastqFile = file,
                outputDir = outputDir
        }
    }

    # Output definitions
    output {
        # An array of output ZIP files containing the FastQC results
        Array[File] outputFiles1 = runFastQC.fastqcOutput1
        # An array of output HTML files containing the FastQC reports
        Array[File] outputFiles2 = runFastQC.fastqcOutput2
    }
}

# Define a task to run FastQC on a single FASTQ file using Docker
task runFastQC {
    # Input parameters
    input {
        # The input FASTQ file
        File fastqFile
        # The directory where the output will be stored
        String outputDir
    }

    # Derive the base name of the FASTQ file without the extension
    String baseName = sub(basename(fastqFile), "\\.(fastq|fq)(\\.gz|\\.bz2|\\.xz)?$", "") #error witht the dxcompiler

    # Command to run FastQC using the Docker image
    command {
        # Run FastQC on the input FASTQ file and output the results to the specified output directory
        docker run --rm -v ~{fastqFile}:/data/input.fastq.gz -v ~{outputDir}:/output biocontainers/fastqc:v0.11.9_cv8 fastqc /data/input.fastq.gz -o /output/
    }

    # Output definitions
    output {
        # The output ZIP file containing the FastQC results
        File fastqcOutput1 = "${outputDir}/${baseName}_fastqc.zip"
        # The output HTML file containing the FastQC report
        File fastqcOutput2 = "${outputDir}/${baseName}_fastqc.html"
    }

    # Specify the Docker container to use
    runtime {
        docker: "biocontainers/fastqc:v0.11.9_cv8"
    }
}
