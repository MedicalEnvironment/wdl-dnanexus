<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRebnHAXPaao5YNF58wnzLnc2jhY9YqsDLNx62BSnbj8JeZVwMiUG_DFU_v4SMcveoGxQ&usqp=CAU" alt="DNAnexus Platform Image" width="200" style="margin-right: 10px;">
  <img src="https://vsmalladi.github.io/openwdl.github.io//media/logo-preview.png" alt="OpenWDL Logo" width="200" style="margin-right: 10px;">
  <img src="https://cltchighereducation.com/wp-content/uploads/2021/06/download-4.jpeg" alt="Download Icon" width="200">
</p>


## Compiling the WDL Workflow with `dxCompiler`

**Introduction**

This guide provides step-by-step instructions on compiling a WDL workflow using `dxCompiler` for the DNAnexus platform. We'll demonstrate this process with a FastQC subworkflow. 

**Please note that the files in this directory were developed specifically for FastQC sequence analyses!.**

**Prerequisites**

* **DNAnexus Account:** Ensure you have a DNAnexus account.
* **DX Toolkit:** Install the DNAnexus Toolkit (`dx-toolkit`) to interact with the DNAnexus platform: [Installation guide](https://documentation.dnanexus.com/downloads)
* **Java:** You'll need Java JDK to run `dxCompiler`. Download it from the official website: [Installation page](https://github.com/dnanexus/dxCompiler/releases)
* **dxCompiler**: Download the latest version of `dxCompiler` (e.g., `dxCompiler-2.11.7.jar`) from the official releases page:  [Installation page](https://github.com/dnanexus/dxCompiler/releases)

**Important Note!**

`dxCompiler` is only compatible with Java 8 and 11.

**Installing DX Toolkit**

1. **Download:** Download the appropriate DX Toolkit installer for your operating system from the DNAnexus website: [DNAnexus Toolkit Installation](https://documentation.dnanexus.com/downloads)
2. **Installation:** Follow the installation instructions provided for your specific operating system. This usually involves running the installer and following the on-screen prompts.
3. **Configuration:** Detailed tutorial you can find by accessing this link [Command Line Guide](https://documentation.dnanexus.com/getting-started/cli-quickstart)
   ```bash
   dx login  # Login to DNAnexus before using this command
   dx projects list
   ```

**Compiling and Deploying the Workflow**

To compile your WDL workflow using `dxCompiler` and deploy it to DNAnexus, follow these steps:

1. **Prepare Your WDL File:**
   - Ensure you have the `fastqc_subworkflow.wdl` file containing your workflow definition.

2. **Run the `dxCompiler` Command:**

   Execute the following command in your terminal:

   ```bash
   java -jar dxCompiler-2.11.7.jar compile fastqc_subworkflow.wdl \
       --project project-<project_id> \
       --folder "<directory_name>"
   ```

   **Explanation of the command:**

   - `java -jar dxCompiler-2.11.7.jar`: This part invokes the `dxCompiler` tool.
   - `compile fastqc_subworkflow.wdl`: This specifies the WDL file to be compiled.
   - `--project project-<project_id>`: This argument indicates the DNAnexus project ID where the compiled workflow will be stored. Replace `<project_id>` with your actual project ID.
   - `--folder "<directory_name>"`: This argument specifies the folder within your DNAnexus project where the compiled workflow will be placed. Replace `<directory_name>` with the desired folder name.

3. **Check Workflow Progress on the DNAnexus Platform**

   Once the compilation is complete, you can monitor the workflow's progress directly on the DNAnexus platform. Here's how:

   1. **Log in to DNAnexus:** Access the DNAnexus website and log in to your account.
   2. **Navigate to Your Project:** Go to the project where you compiled the workflow.
   3. **Locate the Workflow:** Look for the newly created workflow in the project's file explorer.
   4. **Monitor Execution:** Click on the workflow to view its status, logs, and output files.

By following these steps and leveraging the power of `dxCompiler`, you can efficiently compile and deploy your WDL workflows on the DNAnexus platform.



**Troubleshooting**
- **Compilation Errors:**
  - **Syntax Errors:** Double-check your WDL syntax for errors like missing semicolons, incorrect indentation, or typos.
  - **Missing Dependencies:** Ensure that all necessary tools and libraries, including Docker images, are properly defined and accessible.
  - **Permission Issues:** Verify that you have the necessary permissions to create and modify files and directories in your DNAnexus project.
- **Workflow Execution Errors:**
  - **Input File Issues:** Ensure that your input files are correctly formatted and uploaded to DNAnexus.
  - **Task Failures:** Check the logs of failed tasks to identify specific error messages.
  - **Resource Constraints:** If your workflow requires significant computational resources, consider adjusting the resource allocations.
- **DNAnexus Platform Issues:**
  - **Network Connectivity:** Verify your internet connection and ensure that you can access the DNAnexus platform.
  - **API Token:** Double-check that your API token is valid and configured correctly.
  - **Project Permissions:** Ensure that you have the necessary permissions to run workflows and access results in your DNAnexus project.


By following these instructions and leveraging the power of the DX Toolkit, you can efficiently compile, deploy, and manage your WDL workflows on the DNAnexus platform.
