# FastQC Nextflow Pipeline for DNAnexus

Nextflow pipeline for running FastQC quality control on FASTQ files. Converted from WDL to Nextflow DSL2.

## Files Used

```
fastqc-dnanexus/
├── main.nf              # Main pipeline script
├── nextflow.config      # Configuration with docker profile
└── nextflow_schema.json # Parameter schema for DNAnexus UI
```

**Docker Container:** `akbarabayev/my-fastqc-dnanexus-image:latest`

## Commands

### Build and Deploy to DNAnexus
```bash
dx build --nextflow . \
  --destination project-Gfb3PGj46zGzp14Y3gPZZfBb:/nextflow-dnanex \
  --overwrite
```

### Run on DNAnexus
```bash
# Single file
dx run project-Gfb3PGj46zGzp14Y3gPZZfBb:/nextflow-dnanex \
  -inextflow_run_opts='-profile docker --fastq_files "dx://project-Gfb3PGj46zGzp14Y3gPZZfBb:/DATA/INPUT/RNA-seq/R1/sod1_R1_001.fastq.gz" --outdir nextflow-output' \
  --destination project-Gfb3PGj46zGzp14Y3gPZZfBb:/nextflow-output/ \
  -y

# Multiple files (glob pattern)
dx run project-Gfb3PGj46zGzp14Y3gPZZfBb:/nextflow-dnanex \
  -inextflow_run_opts='-profile docker --fastq_files "dx://project-Gfb3PGj46zGzp14Y3gPZZfBb:/DATA/INPUT/RNA-seq/R1/*.fastq.gz" --outdir nextflow-output' \
  --destination project-Gfb3PGj46zGzp14Y3gPZZfBb:/nextflow-output/ \
  -y

# Monitor job
dx watch <job-id>
```

### Run Locally
```bash
nextflow run main.nf \
  --fastq_files 'data/*.fastq.gz' \
  --outdir results \
  -profile docker
```

## Key Configuration (nextflow.config)

### Docker Profile (Required for DNAnexus)
```groovy
profiles {
    docker {
        process.container = 'akbarabayev/my-fastqc-dnanexus-image:latest'
        docker.enabled = true
        docker.runOptions = '-u $(id -u):$(id -g)'
    }
}
```

### Process Resources
```groovy
process {
    cpus   = 2
    memory = 4.GB
    time   = 2.h
    errorStrategy = 'retry'
    maxRetries    = 2
}
```

### Important Settings
```groovy
// Prevent trace file conflicts on DNAnexus
trace {
    enabled = true
    overwrite = true
}

// Docker disabled globally (enabled only in docker profile)
docker {
    enabled = false
}
```

## Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `fastq_files` | (required) | Path or glob pattern to FASTQ files |
| `outdir` | `./results` | Output directory |
| `max_cpus` | `4` | Maximum CPUs per process |
| `max_memory` | `8.GB` | Maximum memory per process |

## WDL to Nextflow Conversion

| WDL | Nextflow |
|-----|----------|
| `workflow fastqc_subworkflow` | `workflow { }` block |
| `task runFastQC` | `process runFastQC` |
| `scatter(file in fastqFiles)` | `Channel.fromPath(params.fastq_files)` |
| `runtime.docker` | `process.container` in docker profile |
| `Array[File]` | String glob pattern |

---

**Version:** 1.0.0  
**Last Updated:** November 2025
