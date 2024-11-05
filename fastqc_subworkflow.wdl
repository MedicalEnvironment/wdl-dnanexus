version 1.0

workflow fastqc_subworkflow {
    input {
        Array[File] fastqFiles
    }
    scatter(file in fastqFiles) {
        call runFastQC {
            input:
                fastqFile = file
        }
    }
    output {
        Array[File] outputFiles1 = runFastQC.fastqcOutput1
        Array[File] outputFiles2 = runFastQC.fastqcOutput2
    }
}

task runFastQC {
    input {
        File fastqFile
    }
    String baseName = sub(basename(fastqFile), "\\.(fastq|fq)(\\.gz|\\.bz2|\\.xz)?$", "")
    command {
        fastqc --outdir /home/dnanexus/outputs ${fastqFile}
    }
    output {
        File fastqcOutput1 = "/home/dnanexus/outputs/${baseName}_fastqc.zip"
        File fastqcOutput2 = "/home/dnanexus/outputs/${baseName}_fastqc.html"
    }
    runtime {
        docker: "akbarabayev/my-fastqc-dnanexus-image:latest"
    }
}
