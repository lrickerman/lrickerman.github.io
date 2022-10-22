---
layout: default
title: NYWWS
---


# NYWWS--GENEXUS FILE TRANSFER
Genexus .bam File Transfer to GCP

**_NOTE THAT THE GCP LINK WILL CHANGE. THIS WILL BE UPDATED TO REFLECT THE CHANGES WHEN THE NEW LINK IS ANNOUNCED._**

### Introduction

The NYWWS.sh script transfers the processed bam files (*.merged.bam.ptrim.bam) to the NYWWS GCP at Syracuse for analysis.

The process includes the following:
1. SSH connection to the local Genexus instrument
2. Searching the instrument for the most recent processed bam files
3. Copying these files into /tmp/nywws/
4. Renaming the files according to the ID specified when the Genexus run was initiated (i.e. the sample ID)
5. Uploading the processed bam files under the sample ID name in the correct facility location folder
6. Logging all data into a genexus.log file
 
 
### Wiki

The [Wiki](./Home.md) includes instructions for [Ubuntu installation](./1-Ubuntu-installation.md), [Manual file retrieval](./0-Manual-file-retrieval.md), [SSH key creation](./2-SSH-key-creation.md), and [WSL data retrieval and transfer](./3-WSL-data-retrieval-and-transfer.md). These are alternatives to using the script.
 
 
### Dependencies

* SSH key (private and public)
* Instrument IP address
* [Python3.8+](https://www.python.org/downloads/)
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
* [Bash 4.0+](https://www.gnu.org/software/bash/) - NOTE: if running macOS with Bash v3, [Conda](https://docs.conda.io/en/latest/miniconda.html) environment with Bash v4 or higher is required
 
 
## Download NYWWS.sh
To download the script, <a href="NYWWS.sh">Click Here</a>. Make sure it is in a place you can navigate to from WSL. It is recommended to move the file to your home directory.

* Ex. if NYWWS.sh is saved to your desktop, you can move it to your home directory with the following:

{% highlight ruby %}
cd
mv /mnt/c/Users/[NAME]/Desktop/NYWWS.sh .
{% endhighlight %}
 
## Execute
To run the script:

{% highlight ruby %}
./NYWWS.sh
{% endhighlight %}

Prompts will appear that you will answer.
