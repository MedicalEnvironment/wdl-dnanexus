# How to Create a New GitHub Repository from This Directory

## Step 1: Initialize Git in This Directory

```bash
cd C:\Users\Asus\wdl-dnanexus
git init
```

## Step 2: Add Files to Git

```bash
git add main.nf nextflow.config nextflow_schema.json NEXTFLOW_DEPLOYMENT_GUIDE.md .gitignore README_NEXTFLOW.md
git commit -m "Initial commit: Nextflow pipeline for DNAnexus"
```

## Step 3: Create a New Repository on GitHub

1. Go to https://github.com/new
2. Repository name: `fastqc-nextflow-dnanexus` (or your preferred name)
3. Description: "FastQC Nextflow pipeline for DNAnexus Platform"
4. Choose Public or Private
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click "Create repository"

## Step 4: Link Local Directory to GitHub and Push

GitHub will show you commands like these - copy and run them:

```bash
git remote add origin https://github.com/YOUR-USERNAME/fastqc-nextflow-dnanexus.git
git branch -M main
git push -u origin main
```

Replace `YOUR-USERNAME` with your actual GitHub username.

## Done!

Your new repository will contain:
- `main.nf` - Nextflow pipeline
- `nextflow.config` - Configuration
- `nextflow_schema.json` - Parameter schema
- `NEXTFLOW_DEPLOYMENT_GUIDE.md` - Deployment guide
- `.gitignore` - Git ignore rules
- `README_NEXTFLOW.md` - Main README

You can then rename `README_NEXTFLOW.md` to `README.md` on GitHub if desired.
