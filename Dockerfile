# Start with the FastQC image
FROM biocontainers/fastqc:v0.11.9_cv8

# Set up the working directory
WORKDIR /wdl-dnanexus

# Copy workflow files to the Docker image
COPY fastqc_subworkflow.wdl /wdl-dnanexus/fastqc_subworkflow.wdl

# Create the output directory
RUN mkdir -p /home/dnanexus/outputs

# Default command is empty; DNAnexus handles execution
CMD ["/bin/bash"]
