## Compiling the WDL Workflow with `dxCompiler`

**Introduction**  
This guide provides a complete, step-by-step walkthrough for compiling a WDL workflow using `dxCompiler` on the DNAnexus platform. We'll use a FastQC subworkflow as an example and ensure all steps are clearly explained with specific examples and screenshots to leave no room for ambiguity.

---

### **1. Purpose of the Dockerfile**

**What is the purpose of the Dockerfile?**  
The Dockerfile ensures that all necessary dependencies (e.g., FastQC and its required environment) are packaged into a portable, reproducible container. This container guarantees the workflow behaves consistently across different systems.

**Why are we using it?**  
By specifying a Docker image in your workflow, you ensure compatibility with the DNAnexus platform. In this case, the `biocontainers/fastqc:v0.11.9_cv8` Docker image includes all tools required to run the FastQC subworkflow.

**Dockerfile Example:**
```Dockerfile
# Start with the FastQC image
FROM biocontainers/fastqc:v0.11.9_cv8

# Set the working directory
WORKDIR /wdl-dnanexus

# Copy the WDL workflow file
COPY fastqc_subworkflow.wdl /wdl-dnanexus/

CMD ["/bin/bash"]
```

This Dockerfile:  
1. Pulls the pre-built `biocontainers/fastqc` image.  
2. Sets a working directory (`/wdl-dnanexus`).  
3. Copies the WDL workflow (`fastqc_subworkflow.wdl`) into the container.  

---

### **2. Setup with Specific Examples**

**Input Files**:  
Let’s assume your input directory contains two FASTQ files for analysis:  
- `sample1.fastq`  
- `sample2.fastq`

**Output Directory**:  
The results will be stored in the DNAnexus folder `/FastQC_Results`.

**How to upload input files**:  
1. Log in to the DNAnexus GUI.  
2. Navigate to your project.  
3. Drag and drop the files into the `Input_Files` folder (or use the CLI: `dx upload sample1.fastq sample2.fastq --folder /Input_Files`).  

---

### **3. Installing the DX Toolkit**

To compile WDL workflows, you need the DNAnexus CLI tools (`dx toolkit`).

**Steps:**  
1. **Download**: Download the toolkit for your OS: [DNAnexus Toolkit Installation](https://documentation.dnanexus.com/downloads).  
2. **Install**: Follow your system's installation instructions.  
   Example for Linux:
   ```bash
   curl -O https://dnanexus.com/downloads/dx-toolkit.tar.gz
   tar -xvzf dx-toolkit.tar.gz
   cd dx-toolkit
   sudo ./install
   ```
3. **Login**: After installation, log in with your DNAnexus account:  
   ```bash
   dx login
   ```
4. **Find Project ID**: List your DNAnexus projects:  
   ```bash
   dx find projects
   ```
   Example output:  
   ```
   ID              NAME
   project-12345   FastQC_Project
   ```

---

### **4. Compiling and Deploying the Workflow**

**Command Example:**  
Run the `dxCompiler` command from your local machine or HPC terminal where `dxCompiler` is installed.

```bash
java -jar dxCompiler-2.11.7.jar compile fastqc_subworkflow.wdl \
    --project project-12345 \
    --folder "/WDL_Compiled_Workflows"
```

**Explanation of Flags:**
- `--project project-12345`: The DNAnexus project where the compiled workflow will be saved.  
- `--folder "/WDL_Compiled_Workflows"`: The folder path for storing the compiled workflow. Ensure it starts with `/`.  

**Common Error:**  
If you see `[error] Folder path must start with "/"`, check the folder argument. For example, use `"/WDL_Compiled_Workflows"` instead of `"WDL_Compiled_Workflows"`.

---

### **5. Checking Workflow Progress on DNAnexus**

After compilation, the workflow is transferred to DNAnexus but not executed. To execute it:  
1. Log in to the DNAnexus GUI.  
2. Navigate to the **Workflows** section.  
3. Locate the `fastqc_subworkflow` in the specified folder (`/WDL_Compiled_Workflows`).  
4. Run the workflow by configuring inputs and outputs (details in the next section).  

---

### **6. Setting Input Files and Output Directory**

**Input Configuration**:  
Use the DNAnexus GUI to set up the inputs:  
1. Open the compiled workflow.  
2. Navigate to the **Inputs** tab. Refer to the screenshot below:

   ![Inputs Tab](https://github.com/user-attachments/assets/fdece1ba-985b-4bf5-b678-4442357f03f3)

3. Select `fastqFiles` by clicking **Select Files (array)** and choose `sample1.fastq` and `sample2.fastq` from your project.  

**Output Configuration**:  
1. Switch to the **Outputs** tab.  

   ![Outputs Tab](https://github.com/user-attachments/assets/cf0aa98d-ac47-4908-8fb2-90edd7b3f0e7)

2. Set the **Output Folder** to `/FastQC_Results`.  

---

### **7. Running the Workflow**

Click the **Run** button. The workflow will execute on DNAnexus, and you’ll receive a notification upon completion. Use the screenshots for guidance during this step:

   ![Run Workflow](https://github.com/user-attachments/assets/e79b8e31-3ed9-41a9-b586-8773c5069144)

---

### **8. Troubleshooting**

**Compilation Errors**:  
- **Syntax Errors**: Check your WDL file for syntax issues.  
- **Missing Files**: Ensure input files are uploaded and paths are correct.  

**Execution Errors**:  
- Check the logs of failed tasks directly in DNAnexus.  

**General Tips**:  
- Always test workflows locally or in a sandbox project before deploying.  
