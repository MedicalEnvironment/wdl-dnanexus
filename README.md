<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRebnHAXPaao5YNF58wnzLnc2jhY9YqsDLNx62BSnbj8JeZVwMiUG_DFU_v4SMcveoGxQ&usqp=CAU" alt="DNAnexus Platform Image" width="400" style="margin-right: 10px;">
  <img src="https://vsmalladi.github.io/openwdl.github.io//media/logo-preview.png" alt="OpenWDL Logo" width="300" style="margin-right: 10px;">
</p>

### **Installing the DX Toolkit and Java (Required for dxCompiler)**

To compile WDL workflows, you need the DNAnexus CLI tools (`dxToolkit`) and a specific version of Java (either version 8 or version 11). These Java versions are required as they are the only ones supported for running `dxCompiler`.

#### **Steps for Installing Java Version 8 or 11:**

**Option 1: Install Java 8 (Recommended)**
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

**Option 2: Install Java 11** (if Java 8 is unavailable)

1. **Download Java 11**:  
   Java 11 can be downloaded from the official Oracle website or use an OpenJDK version.  
   [Oracle JDK 11 download](https://www.oracle.com/java/technologies/downloads/#java11)  

2. **Install Java 11**:  
   Follow the installation instructions specific to your operating system:

   **For Linux (Ubuntu/Debian)**:
   ```bash
   sudo apt update
   sudo apt install openjdk-11-jdk
   ```

   **For Windows**:
   Run the installer and follow the steps, ensuring that the JDK is added to the `PATH` environment variable during installation.

   **For macOS**:
   You can install Java 11 via Homebrew:
   ```bash
   brew install openjdk@11
   ```

3. **Verify Installation**:  
   After installation, verify that Java 11 is installed correctly by running:
   ```bash
   java -version
   ```
   You should see an output like:
   ```
   openjdk version "11.0.x" 202x-xx-xx
   ```

---

### **Installing the DX **

Now that you have Java installed (version 8 or 11), you can proceed with installing the DNAnexus CLI tools, which include `dxCompiler`.

1. **Download the DX Toolkit**:
   Go to the DNAnexus documentation page to download the toolkit suitable for your operating system:  
   [DNAnexus Toolkit Installation](https://documentation.dnanexus.com/downloads)

2. **Install the DX Toolkit**:
   - **For Unix Like**:
     ```bash
     pip3 install dxpy
     ```

   - **For Windows**:
     The installation process on Windows requires you to download the installer, unzip the file, and follow the installation steps included in the downloaded archive.

3. **Login to DNAnexus**:
   Once the installation is complete, log in to your DNAnexus account:
   ```bash
   dx login
   ```

4. **Verify Installation**:
   Verify that the `dx` CLI is installed and accessible:
   ```bash
   dx --version
   ```

### **Installing the dxCompiler**
To download the latest version, visit the following link: https://github.com/dnanexus/dxCompiler/releases

To install dxCompiler via the CLI, run the following commands:
```bash
wget https://github.com/dnanexus/dxCompiler/releases/download/2.11.9/dxCompiler-2.11.9.jar
cd /where/you/want/it; jar xf /path/to/jarfile.jar
```

---

### **Important Note on Java Versions for dxCompiler**

- **Java 8 and 11 Only**:  
  `dxCompiler` supports only Java version 8 and Java version 11. Using any other version of Java (e.g., Java 17 or newer) may lead to errors or unexpected behavior when compiling WDL workflows.

---

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

### **5. Setting Input Files and Output Directory**

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

### **6. Monitoring Workflow Progress on DNAnexus**

1. Go to the **Monitor** section within the DNAnexus interface (**As you may have already noticed, the number "1" has popped up, indicating that the workflow has been started**).

   ![image](https://github.com/user-attachments/assets/f2ba6343-b781-4f23-934b-f116717cc3b6)

2. Select the name of your current workflow process. In this example, it is `fastqc_subworkflow`.

   ![image](https://github.com/user-attachments/assets/5a976549-127d-4708-82ab-00687396202a)

3. On the detailed process page, you can view real-time logs and periodic updates, such as the date and time of the process execution.

   ![image](https://github.com/user-attachments/assets/3a0aa101-1f8e-4c97-a643-098769c29ce4)

---

### **7. Troubleshooting**

**Compilation Errors**:  
- **Syntax Errors**: Check your WDL file for syntax issues.  
- **Missing Files**: Ensure input files are uploaded and paths are correct.  

**Execution Errors**:  
- Check the logs of failed tasks directly in DNAnexus.  

**General Tips**:  
- Always test workflows locally or in a sandbox project before deploying.  
