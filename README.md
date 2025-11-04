<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRebnHAXPaao5YNF58wnzLnc2jhY9YqsDLNx62BSnbj8JeZVwMiUG_DFU_v4SMcveoGxQ&usqp=CAU" alt="DNAnexus Platform Image" width="400" style="margin-right: 10px;">
  <img src="https://vsmalladi.github.io/openwdl.github.io//media/logo-preview.png" alt="OpenWDL Logo" width="300" style="margin-right: 10px;">
</p>

# WDL Workflow Deployment Guide

This repository contains both **WDL** and **Nextflow** implementations for deploying FastQC workflows to DNAnexus.

> **Note:** For Nextflow deployment instructions, see [README_NEXTFLOW.md](README_NEXTFLOW.md)

---

### **Installing the DX Toolkit and Java (Required for dxCompiler)**

To compile WDL workflows, you need the DNAnexus CLI tools (`dxToolkit`) and a specific version of Java (either version 8 or version 11). These Java versions are required as they are the only ones supported for running `dxCompiler`. 

**Additionally, to explore the full potential of working with the DX toolkit, you can refer to this documentation ([Link](https://documentation.dnanexus.com/getting-started/cli-quickstart)) for guidance on utilizing its extensive command arsenal in various scenarios. However, for now, we will focus on using the GUI to avoid any confusion.**

#### **Steps for Installing Java Version 8 (Recommended):**
1. **Download Java 8**:  
   Download the Java 8 JDK from the official Oracle website or use an OpenJDK version.  
   [Oracle JDK 8 download](https://www.oracle.com/java/technologies/downloads/#java8) 

2. **Install Java 8**:  
   Follow the installation instructions specific to your operating system:
   
   **For Linux (Ubuntu/Debian)**:
   ```bash
   sudo apt update
   sudo apt install openjdk-8-jdk
   ```

   **For Windows**:
   Run the installer and follow the steps, ensuring that the JDK is added to the `PATH` environment variable during installation.

   **For macOS**:
   You can install Java 8 via Homebrew:
   ```bash
   brew install --cask adoptopenjdk8
   ```

3. **Verify Installation**:  
   After installation, verify that Java 8 is installed correctly by running:
   ```bash
   java -version
   ```
   You should see an output like:
   ```
   openjdk version "1.8.0_xx"
   ```

---

### **Installing the DX Toolkit**

Now that you have Java installed (version 8 or 11), you can proceed with installing the DNAnexus CLI tools, which include `dxCompiler` and `dx toolkit`.

1. **Download the DX Toolkit**:
   Go to the DNAnexus documentation page to check the detailed tutorial on the installation process:  
   [DNAnexus Toolkit Installation](https://documentation.dnanexus.com/downloads)

2. **Install the DX Toolkit**:
     ```bash
     pip3 install dxpy
     ```

3. **Verify Installation**:
   Verify that the `dx` CLI is installed and accessible:
   ```bash
   dx --version
   ```

4. **Login to DNAnexus**:
   Once the installation is complete, log in to your DNAnexus account:
   ```bash
   dx login
   ```

5. **Find Project ID**: List your DNAnexus projects:  
   ```bash
   dx find projects
   ```
   Example output:  
   ```
   ID              NAME
   project-12345   FastQC_Project
   ```

### **Installing the dxCompiler**
To download the latest version, visit the following link: https://github.com/dnanexus/dxCompiler/releases

To install dxCompiler via the CLI, run the following commands (current dxCompiler version for this tutorial is `2.11.9`):
```bash
wget https://github.com/dnanexus/dxCompiler/releases/download/2.11.9/dxCompiler-2.11.9.jar
cd /where/you/want/it; jar xf /path/to/jarfile.jar
```

Or by using the `curl` command:
```bash
curl -L -o dxCompiler-2.11.9.jar https://github.com/dnanexus/dxCompiler/releases/download/2.11.9/dxCompiler-2.11.9.jar
```
If wget or curl are unavailable, here’s what you can do:

Install the Tool:
Linux: Use `sudo apt-get install wget` or `sudo apt-get install curl`.

MacOS: Use `brew install wget` or `brew install curl`.

Use Alternatives:

Web Browser: `Paste the URL into the browser and download manually`.

---

### **Important Note on Java Versions for dxCompiler**

- **Java 8 and 11 Only**:  
  `dxCompiler` supports only Java version 8 and Java version 11. Using any other version of Java (e.g., Java 17 or newer) may lead to errors or unexpected behavior when compiling WDL workflows.

---

## Compiling the WDL Workflow with `dxCompiler`

**Introduction**  
This guide provides a complete, step-by-step walkthrough for compiling a WDL workflow using `dxCompiler` on the DNAnexus platform. We'll use a FastQC subworkflow as an example and ensure all steps are clearly explained with specific examples and screenshots to leave no room for ambiguity.

---

### **1. Setup with Specific Examples**

**Input Files**:  
Let’s assume your input directory contains FASTQ files for analysis:  
- `input_data`

**Output Directory**:  
The results will be stored in the DNAnexus folder `/FastQC_Results`.

**How to upload input files**:  
1. Log in to the DNAnexus GUI.  
2. Navigate to your project.  
3. Drag and drop the files into the `input_data` folder (or use the CLI: `dx upload input_data --recursive --folder /input_data`).  

---

### **2. Compiling and Deploying the Workflow**

**Note:**
Always validate WDL files before compiling to catch syntax or structural errors.

To install `womtool` version 87 and validate a WDL file:

1. **Download `womtool-87.jar`:**  
   If `wget` is available:
   ```bash
   wget https://github.com/broadinstitute/cromwell/releases/download/87/womtool-87.jar
   ```
   If `curl` is available:
   ```bash
   curl -LO https://github.com/broadinstitute/cromwell/releases/download/87/womtool-87.jar
   ```

2. **Validate the WDL File:**  
   Run the following command to validate your WDL file (e.g., `fastqc_subworkflow.wdl`):  
   ```bash
   java -jar womtool-87.jar validate fastqc_subworkflow.wdl
   ```  

3. **Ensure Java is Installed:**  
   If the `java` command is unavailable, install Java:
   - On Linux: `sudo apt install default-jre`
   - On MacOS: `brew install java`
   - On Windows: Download from [Oracle](https://www.oracle.com/java/technologies/javase-downloads.html). 

**Command Example:**  
Run the `dxCompiler` command from your local machine or HPC terminal where `dxCompiler` is installed.

```bash
java -jar dxCompiler-2.11.7.jar compile fastqc_subworkflow.wdl \
    --project project-12345 \
    --folder "/WDL_Compiled_Workflows"
```

**Explanation of Flags:**
- `--project project-12345`: The DNAnexus project where the compiled workflow will be saved. You can see your project ID by running the following command:
```bash
dx find projects  
```
- `--folder "/WDL_Compiled_Workflows"`: The folder path for storing the compiled workflow. Ensure it starts with `/`.  

**Common Error:**  
If you see `[error] Folder path must start with "/"`, check the folder argument. For example, use `"/WDL_Compiled_Workflows"` instead of `"WDL_Compiled_Workflows"`.

---

### **3. Setting Input Files and Output Directory**

**Input Configuration**:  
Use the DNAnexus GUI to set up the inputs:  
1. Open the compiled workflow.
   - **The compiled workflow will have a Type/Class named "Workflow"**

   ![Inputs Tab](https://github.com/user-attachments/assets/68076222-8762-4c8a-97cd-85df7c20d588)

   - **Click "Next"**

   ![Inputs Tab](https://github.com/user-attachments/assets/a0fcf977-8c5b-4c9f-85fc-3387c45ad89f)

2. Navigate to the **Inputs** tab. Refer to the screenshot below:

   ![Inputs Tab](https://github.com/user-attachments/assets/fdece1ba-985b-4bf5-b678-4442357f03f3)

3. Select `fastqFiles` by clicking **Select Files (array)** and choose `sample1.fastq` and `sample2.fastq` or any other directory with the required data from your project.  

**Output Configuration**:  
1. Switch to the **Outputs** tab.  

   ![Outputs Tab](https://github.com/user-attachments/assets/cf0aa98d-ac47-4908-8fb2-90edd7b3f0e7)

2. Set the **Output Folder** to `/FastQC_Results`.

3. Click the **Run** button. The workflow will execute on DNAnexus, and you’ll receive a notification upon completion:

   ![Run Workflow](https://github.com/user-attachments/assets/e79b8e31-3ed9-41a9-b586-8773c5069144)

---

### **4. Monitoring Workflow Progress on DNAnexus**

1. Go to the **Monitor** section within the DNAnexus interface (**As you may have already noticed, the number "1" has popped up, indicating that the workflow has been started**).

   ![image](https://github.com/user-attachments/assets/f2ba6343-b781-4f23-934b-f116717cc3b6)

2. Select the name of your current workflow process. In this example, it is `fastqc_subworkflow`.

   ![image](https://github.com/user-attachments/assets/69033a2d-584d-4f58-bcce-a30e67c5ce76)

3. On the detailed process page, you can view real-time logs and periodic updates, such as the date and time of the process execution.

   ![image](https://github.com/user-attachments/assets/ad361c3b-6613-4376-8f59-0c330ff02190)


---

### **(Alternatively)** **5. Running the Compiled Workflow via CLI**
Assuming the user has created an **outputs** directory in `/WDL_Compiled_Workflows`, run the following command:  

```bash
dx run workflow-Gy4JkY047*** -f fastqc_subworkflow_inputs.json \
    -y --watch --destination project-12345:/WDL_Compiled_Workflows/outputs/
```

**Explanation of Parameters:**
- `dx run workflow-Gy4JkY047***` → Runs the compiled workflow.  
- `-f fastqc_subworkflow_inputs.json` → Specifies the input file.  
- `-y` → Automatically confirms the execution without asking for confirmation.  
- `--watch` → Allows the user to monitor the job progress in real time.  
- `--destination project-12345:/WDL_Compiled_Workflows/outputs/` → Saves outputs in the **specified DNAnexus project and directory**.  

### **Expected Output Upon Successful Submission:**  
```bash
Analysis ID: analysis-Gy4QXxQ47***  
```
This confirms that the workflow execution has been successfully submitted to DNAnexus.

---

### **6. Troubleshooting**

**Compilation Errors**:  
- **Syntax Errors**: Check your WDL file for syntax issues.  
- **Missing Files**: Ensure input files are uploaded and paths are correct.  

**Execution Errors**:  
- Check the logs of failed tasks directly in DNAnexus.  

**General Tips**:  
- Always test workflows locally or in a sandbox project before deploying.  
