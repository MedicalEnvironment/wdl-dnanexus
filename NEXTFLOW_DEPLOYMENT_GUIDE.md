# FastQC Pipeline - Nextflow Deployment Guide for DNAnexus

<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRebnHAXPaao5YNF58wnzLnc2jhY9YqsDLNx62BSnbj8JeZVwMiUG_DFU_v4SMcveoGxQ&usqp=CAU" alt="DNAnexus Platform Image" height="80" style="margin-right: 20px;">
  <img src="https://repository-images.githubusercontent.com/9052236/ecd9481e-f4b3-4324-b832-a08ee1d99564" alt="Nextflow Logo" height="80">
</p>

## Overview

This guide provides complete instructions for deploying the FastQC Nextflow pipeline to the DNAnexus Platform. The pipeline has been converted from WDL to Nextflow DSL2 and is optimized for DNAnexus execution.

---

## Pipeline Structure

The Nextflow pipeline consists of the following files:

```
fastqc-pipeline/
├── main.nf                    # Main pipeline script
├── nextflow.config            # Configuration file
├── nextflow_schema.json       # Input parameter schema (for DNAnexus integration)
└── NEXTFLOW_DEPLOYMENT_GUIDE.md  # This file
```

### Key Differences from WDL

| **WDL Concept** | **Nextflow Equivalent** | **Notes** |
|-----------------|-------------------------|-----------|
| `workflow` block | `workflow` block with DSL2 | Similar structure |
| `task` block | `process` block | Process definition |
| `scatter` | Channel operations | Automatic parallelization |
| `Array[File]` input | `Channel.fromPath()` | File channel creation |
| `runtime.docker` | `process.container` | Container specification |
| Output arrays | `emit` declarations | Named outputs |

---

## Prerequisites

### 1. Install DNAnexus Toolkit

```bash
# Install via pip
pip3 install dxpy

# Verify installation
dx --version

# Login to DNAnexus
dx login
```

**Note:** Ensure you have **dx-toolkit version v0.378.0 or later** for Nextflow support.

### 2. Verify Your Project

```bash
# List your projects
dx find projects

# Example output:
# project-Gfb3PGj46zGzp14Y3gPZZfBb : JPND_ALS_2023 (CONTRIBUTE)
# project-GvVgg2047YXkgPXjG6VF1YP7 : Examples (CONTRIBUTE)

# Select your project
dx select project-Gfb3PGj46zGzp14Y3gPZZfBb

# View folders in your project
dx ls
# Example output:
# DATA/
# nextflow-dnanex/
# WDL_Workflow/
# etc.
```

### 3. Verify Billing Access

Your project must have the **billTo** feature enabled for Nextflow pipeline building. Contact DNAnexus Sales if needed.

---

## Understanding Paths: Local vs DNAnexus

**Important:** There are two different types of paths:

1. **Local paths** - Files on your computer (e.g., `~/dxcompiler/`, `C:\Users\Asus\fastqc-dnanexus\`)
2. **DNAnexus paths** - Folders on the platform (e.g., `/nextflow-dnanex/`, `/DATA/`)

When you run `dx build --nextflow`, you specify:
- **Source**: Local directory on your computer (where `main.nf` is located)
- **Destination**: DNAnexus path (where the applet will be stored)

---

## Deployment Options

### Option 1: Build from Local Directory (Recommended)

This method builds the pipeline from files **on your local computer** and uploads the applet **to DNAnexus**.

#### Step 1: Prepare Local Files

First, ensure you have the Nextflow files on your **local computer**:

```bash
# On Windows (PowerShell):
cd C:\Users\Asus\fastqc-dnanexus
dir
# Should show: main.nf, nextflow.config, nextflow_schema.json

# On Linux/Mac:
cd ~/dxcompiler  # or wherever you have the files
ls -la
# Should show: main.nf, nextflow.config, nextflow_schema.json
```

**If you don't have the files locally yet**, copy them from this repository to your local machine.

#### Step 2: Select Your DNAnexus Project

```bash
# Select the project where you want to deploy
dx select project-Gfb3PGj46zGzp14Y3gPZZfBb

# Verify you can see the target folder
dx ls
# You should see: nextflow-dnanex/
```

#### Step 3: Build the Nextflow Applet

Now build from your **local directory** and deploy **to DNAnexus**:

```bash
# Build from current local directory (.) and upload to DNAnexus
dx build --nextflow . \
  --destination project-Gfb3PGj46zGzp14Y3gPZZfBb:/nextflow-dnanex/fastqc-pipeline
```

**Alternative with explicit local path:**

```bash
# Linux/Mac:
dx build --nextflow ~/dxcompiler \
  --destination project-Gfb3PGj46zGzp14Y3gPZZfBb:/nextflow-dnanex/fastqc-pipeline

# Windows (PowerShell):
dx build --nextflow C:\Users\Asus\fastqc-dnanexus \
  --destination project-Gfb3PGj46zGzp14Y3gPZZfBb:/nextflow-dnanex/fastqc-pipeline
```

**Expected Output:**
```
Started builder job job-aaaa
Created Nextflow pipeline applet-zzzz
```

**Explanation:**
- `.` - Current directory containing pipeline files
- `--destination` - Where to store the applet on DNAnexus
- The applet will be named based on the folder structure

#### Alternative: Specify Custom Name

```bash
dx build --nextflow /path/to/fastqc-dnanexus \
  --destination project-xxxxx:/Nextflow_Pipelines/fastqc-pipeline-v1.0
```

---

### Option 2: Import from Git Repository

If you've pushed your Nextflow pipeline to a Git repository:

#### For Public Repository:

```bash
dx build --nextflow \
  --repository https://github.com/YOUR-USERNAME/fastqc-nextflow \
  --destination project-xxxxx:/Nextflow_Pipelines/fastqc-pipeline
```

#### For Private Repository:

First, create a credentials file:

```json
{
  "username": "your-github-username",
  "token": "your-personal-access-token"
}
```

Upload to DNAnexus:

```bash
dx upload git-credentials.json --destination /credentials/
```

Then build:

```bash
dx build --nextflow \
  --repository https://github.com/YOUR-USERNAME/fastqc-nextflow \
  --git-credentials project-xxxxx:/credentials/git-credentials.json \
  --destination project-xxxxx:/Nextflow_Pipelines/fastqc-pipeline
```

---

## Running the Pipeline on DNAnexus

### Method 1: Run via Command Line Interface (CLI)

#### Step 1: View Pipeline Help

```bash
dx run project-xxxxx:/Nextflow_Pipelines/fastqc-pipeline -h
```

This displays all available input parameters.

#### Step 2: Prepare Input Files

Upload your FASTQ files to DNAnexus (if not already uploaded):

```bash
# Upload single file
dx upload sample1.fastq.gz --destination /input_data/

# Upload multiple files
dx upload *.fastq.gz --destination /input_data/

# Upload directory
dx upload input_data/ --recursive --destination /input_data/
```

#### Step 3: Run the Pipeline

**Basic Execution:**

```bash
dx run project-xxxxx:/Nextflow_Pipelines/fastqc-pipeline \
  --nextflow-pipeline-params '{"fastq_files": "dx://project-xxxxx:/input_data/*.fastq.gz"}' \
  --destination project-xxxxx:/output_data/fastqc_results/ \
  -y
```

**With Additional Parameters:**

```bash
dx run project-xxxxx:/Nextflow_Pipelines/fastqc-pipeline \
  -inextflow_params_file=params.json \
  -idebug=true \
  -ipreserve_cache=true \
  --destination project-xxxxx:/output_data/fastqc_results/ \
  -y --watch
```

**Parameter Flags Explained:**
- `-y` - Auto-confirm execution
- `--watch` - Monitor job progress in real-time
- `-idebug=true` - Enable debug logging
- `-ipreserve_cache=true` - Save cache for future resume capability

#### Step 4: Monitor Job Progress

```bash
# Watch job execution
dx watch job-bbbb

# View job tree structure
dx find jobs --origin job-bbbb

# Check specific subjob
dx describe job-cccc
```

---

### Method 2: Run via User Interface (UI)

#### Step 1: Navigate to Your Project

1. Log into [DNAnexus Platform](https://platform.dnanexus.com/)
2. Open your project

#### Step 2: Locate the Pipeline Applet

1. Go to the **Manage** tab
2. Navigate to `/Nextflow_Pipelines/`
3. Click on `fastqc-pipeline`

#### Step 3: Configure Inputs

1. Click **Run Analysis**
2. In the **Nextflow Pipeline Parameters** section:
   - **fastq_files**: Click "Select Files" and choose your FASTQ files
   - Or enter a pattern: `/input_data/*.fastq.gz`

#### Step 4: Configure Outputs

1. Set **Output Folder**: `/output_data/fastqc_results`
2. Optional: Enable **Preserve Cache** for resumability
3. Optional: Enable **Debug Mode** for detailed logs

#### Step 5: Launch

1. Review settings
2. Click **Start Analysis**
3. Switch to **Monitor** tab to track progress

---

## Pipeline Parameters

### Required Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `fastq_files` | String (file pattern) | Input FASTQ files | `"dx://project-xxx:/input/*.fastq.gz"` |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `outdir` | String | `./results` | Output directory |
| `publish_mode` | String | `copy` | How to publish files (`copy`, `symlink`, `move`) |
| `max_cpus` | Integer | `4` | Maximum CPUs per process |
| `max_memory` | String | `8.GB` | Maximum memory per process |
| `max_time` | String | `4.h` | Maximum time per process |

---

## Creating a Parameters File

For complex runs, create a JSON parameters file:

**params.json:**
```json
{
  "fastq_files": "dx://project-xxxxx:/input_data/*.fastq.gz",
  "outdir": "./fastqc_results",
  "max_cpus": 2,
  "max_memory": "4.GB"
}
```

Upload to DNAnexus:

```bash
dx upload params.json --destination /configs/
```

Use in pipeline execution:

```bash
dx run project-xxxxx:/Nextflow_Pipelines/fastqc-pipeline \
  -inextflow_params_file=project-xxxxx:/configs/params.json \
  --destination project-xxxxx:/output/ \
  -y
```

---

## Monitoring and Troubleshooting

### Understanding the Job Tree

Nextflow pipelines on DNAnexus run as a **job tree**:
- **Head Job**: Orchestrates the pipeline
- **Subjobs**: Individual process executions (one per FASTQ file in this case)

### View Job Tree Structure

```bash
dx find jobs --origin job-bbbb
```

**Example Output:**
```
* fastqc-pipeline (done) job-bbbb
├── runFastQC (sample1) (done) job-1111
├── runFastQC (sample2) (done) job-2222
└── runFastQC (sample3) (done) job-3333
```

### View Logs

**Head Job Log:**
```bash
dx watch job-bbbb
```

**Subjob Log:**
```bash
dx watch job-1111
```

### Common Issues

#### Issue 1: "Cannot find any FASTQ files"

**Cause:** File path pattern doesn't match any files

**Solution:**
```bash
# Verify files exist
dx ls /input_data/

# Use correct pattern
"dx://project-xxxxx:/input_data/*.fastq.gz"
```

#### Issue 2: "Container not found"

**Cause:** Docker image not accessible

**Solution:** Verify the container exists and is accessible:
```bash
docker pull akbarabayev/my-fastqc-dnanexus-image:latest
```

Or update `nextflow.config` with a different image.

#### Issue 3: Job Timeout

**Cause:** Process exceeds time limit

**Solution:** Increase time limit in parameters:
```bash
dx run ... -inextflow_run_opts="-process.time='8h'"
```

---

## Resuming Failed Jobs

### Enable Preserve Cache

When launching, enable cache preservation:

```bash
dx run project-xxxxx:/Nextflow_Pipelines/fastqc-pipeline \
  -ipreserve_cache=true \
  ...
```

### Resume Previous Session

```bash
dx run project-xxxxx:/Nextflow_Pipelines/fastqc-pipeline \
  -iresume="last" \
  ...
```

Or specify exact session ID:

```bash
dx run project-xxxxx:/Nextflow_Pipelines/fastqc-pipeline \
  -iresume="0eac8f92-1216-4fce-99cf-dee6e6b04bc2" \
  ...
```

---

## Expected Outputs

After successful execution, outputs are published to the specified destination:

```
output_data/fastqc_results/
├── sample1_fastqc.html
├── sample1_fastqc.zip
├── sample2_fastqc.html
├── sample2_fastqc.zip
└── pipeline_info/
    ├── timeline.html
    ├── report.html
    ├── trace.txt
    └── dag.svg
```

### Output Files Explained

| File | Description |
|------|-------------|
| `*_fastqc.html` | FastQC quality report (human-readable) |
| `*_fastqc.zip` | FastQC results archive |
| `timeline.html` | Pipeline execution timeline |
| `report.html` | Nextflow execution report |
| `trace.txt` | Detailed process execution trace |
| `dag.svg` | Pipeline workflow diagram |

---

## Building a Nextflow App (Optional)

To create a reusable app from your applet:

```bash
dx build --app --from applet-zzzz
```

This creates a global app that can be:
- Shared across projects
- Published to the Tools Library
- Version-controlled

---

## Cost Estimation

Typical costs for FastQC pipeline (estimates only):

| Component | Instance Type | Cost per Hour | Typical Runtime |
|-----------|---------------|---------------|-----------------|
| Head Job | mem1_ssd1_v2_x2 | ~$0.10 | Full pipeline duration |
| FastQC Subjob | mem1_ssd1_v2_x2 | ~$0.10 | 2-5 minutes per file |

**Example:** Processing 10 FASTQ files
- Head job: 15 minutes = $0.025
- 10 subjobs × 3 minutes average = $0.05
- **Total: ~$0.075**

---

## Comparison: WDL vs Nextflow on DNAnexus

| Feature | WDL | Nextflow |
|---------|-----|----------|
| **Build Command** | `java -jar dxCompiler.jar compile` | `dx build --nextflow` |
| **Java Required** | Yes (v8 or v11) | No |
| **Native Support** | Via dxCompiler | Native in dx-toolkit |
| **Resume Capability** | Limited | Full resume support |
| **Execution Reports** | Basic | Comprehensive (timeline, DAG, trace) |
| **Learning Curve** | Moderate | Moderate |

---

## Best Practices

1. **Always include `nextflow_schema.json`** - Enables proper parameter mapping on DNAnexus
2. **Use appropriate instance types** - Configure in `nextflow.config` based on process needs
3. **Enable preserve_cache for long pipelines** - Allows resuming failed runs
4. **Test locally first** - Run `nextflow run main.nf --fastq_files 'test/*.fq'` before deploying
5. **Version your pipelines** - Use meaningful names: `fastqc-pipeline-v1.0`, `fastqc-pipeline-v1.1`
6. **Monitor costs** - Check job costs in the UI Monitor tab
7. **Use debug mode sparingly** - Only enable when troubleshooting

---

## Testing Locally Before Deployment

Before deploying to DNAnexus, test locally:

```bash
# Create test data
mkdir -p test_data
# Add some small test FASTQ files

# Run locally with Docker
nextflow run main.nf \
  --fastq_files 'test_data/*.fastq.gz' \
  --outdir test_results \
  -profile docker

# Check outputs
ls -la test_results/fastqc_results/
```

---

## Additional Resources

- [Nextflow Documentation](https://www.nextflow.io/docs/latest/)
- [DNAnexus Nextflow Documentation](https://documentation.dnanexus.com/developer/workflows/nextflow)
- [DNAnexus CLI Quickstart](https://documentation.dnanexus.com/getting-started/cli-quickstart)
- [FastQC Tool Documentation](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

---

## Support

For issues or questions:
- DNAnexus Platform: [Contact Support](https://support.dnanexus.com/)
- Nextflow: [Community Forum](https://www.nextflow.io/slack.html)

---

## License

Contact DNAnexus Sales for licensing information regarding app/applet creation.

---

**Last Updated:** November 2025  
**dx-toolkit Version:** v0.391.0 or later recommended
