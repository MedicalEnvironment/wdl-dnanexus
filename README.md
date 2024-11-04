![alt text](https://pbs.twimg.com/profile_images/1714671942383636480/kWGpiA6B_400x400.jpg)
# FastQC Subworkflow on DNAnexus

This guide provides instructions on compiling a WDL workflow using `dxCompiler`, deploying it on DNAnexus, and retrieving output. This example uses a FastQC subworkflow.

## Prerequisites

- **DX Toolkit**: Ensure DNAnexus Toolkit (`dx-toolkit`) is installed and configured [Guide on installation process](https://documentation.dnanexus.com/downloads).
- **Java**: Java JDK is required to run `dxCompiler`[Installation page](https://github.com/dnanexus/dxCompiler/releases).
- **dxCompiler**: Download the latest `dxCompiler` jar file (e.g., `dxCompiler-2.11.7.jar`) [Installation page](https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html).
** Important note!
  dxCompiler will only work with Java 8 and 11.
---

## Steps to Compile and Deploy the Workflow

### 1. Prepare WDL and JSON Files

Make sure you have:
- `fastqc_subworkflow.wdl` (WDL script)
- `fastqc_subworkflow_inputs.json` (JSON input file)

### 2. Compile the Workflow

Run the following command to compile the WDL file into a DNAnexus-compatible workflow:

```bash
java -jar dxCompiler-2.11.7.jar compile fastqc_subworkflow.wdl \
    --project project-GvVgg2047YXkgPXjG6VF1YP7 \
    --folder "/WDL/"
```
Parameters:
--project specifies the DNAnexus project ID.
--folder designates the folder on DNAnexus for the compiled workflow.
3. Upload Required Files to DNAnexus
Use the following command to upload any referenced input files to DNAnexus:

```bash
dx upload <input_files_directory> --destination "/WDL/"
Make sure uploaded files match the paths specified in your JSON input file.
```
4. Launch the Workflow
Use dx run to start the workflow. Replace <workflow_id> with the ID from the compilation step:

```bash
dx run <workflow_id> \
    -i fastqc_subworkflow_inputs.json \
    --project project-GvVgg2047YXkgPXjG6VF1YP7 \
    --folder "/Results/"
```
Parameters:
-i points to the JSON input file containing required inputs for the workflow.
--folder specifies the DNAnexus folder where output files will be saved.
5. Monitor Execution
Monitor workflow progress on DNAnexus or via command line:

```bash
dx watch <job_id>
Replace <job_id> with the ID provided when launching the workflow.
```

6. Retrieve Output
Upon completion, navigate to the output folder (/Results/) on DNAnexus, or use:

```bash
dx download "/Results/*" --output /local_directory/
Replace /local_directory/ with your preferred local save location.
```

## Troubleshooting
Output Directory Issues: Verify output directories are correctly defined in the Docker image and WDL script.
Permissions: Ensure upload, run, and view permissions are granted.
Error Logs: Check DNAnexus logs for error details, which may guide necessary adjustments in WDL or Docker configurations.# FastQC Subworkflow on DNAnexus
