---
layout: post
title: "Manual file retrieval"
categories: wiki
---

## Manual file retrieval is time-consuming and is not the preferred option. However, if you would rather not use a script or WSL, it is the only other option.

1. Open an internet browser (e.g., Google Chrome) and login to your genexus instrument. The URL will be the IP address of the genexus. One of the Wadsworth instruments will be used as an example (IP: 10.49.62.65). The following examples are in Google Chrome.
2. In the URL bar, type in the IP address and hit enter. A screen will pop up saying that the connection is not private. In this case, click on ‘Advanced’ and then ‘Proceed to 10.49.62.65 (unsafe)’.
<p align="center">
<img src="https://user-images.githubusercontent.com/62037577/195853750-b66045e4-f7ee-4b24-8895-54a43c4492ca.png" width="700">
</p>
3. Proceed to login to the instrument with your genexus username and password. It is recommended to login as the user ‘ionadmin’.
<p align="center">
<img src="https://user-images.githubusercontent.com/62037577/195853885-8a42f6ab-93cb-4741-b855-d792afedde0b.png" width="700">
</p>
4. On the home screen, navigate to Results > Run Results and your most recent run, or you can click on the rnu name on the 'Recent Runs' sidebar (left, blue).
<p align="center">
<img src="https://user-images.githubusercontent.com/62037577/195870621-6c70a6f8-ba98-4d1e-8ff6-dcedee6e698e.png" width="1200">
</p>
5. Once in the correct run, click Select Assay at the top to select the assay results for the run.
<p align="center">
<img src="https://user-images.githubusercontent.com/62037577/195855097-669d3c15-0822-49ea-96b1-fa96d5f48b25.png">
</p>
6. Click on Select Sample and choose the first sample.
<p align="center">
<img src="https://user-images.githubusercontent.com/62037577/195855338-ef3fe24f-6dd7-4e6b-afba-0428a548cbf2.png">
</p>
7. On the right, click on the ... and Download Files. You will choose Processed Bam File (.bam).
<p align="center">
<img src="https://user-images.githubusercontent.com/62037577/195856047-3fb87f95-ccad-4998-8b2b-18072228637e.png">
<img src="https://user-images.githubusercontent.com/62037577/195856063-6d3ca31a-5aa5-418b-8ca7-b51511c522ad.png" width="500">
</p>
8. A compressed file will be downloaded as '[sample_name]_[runname]_result_[#].zip'. You will need to extract the merged.bam.ptrim.bam file and manually rename it as the sample file.
<p align="center">
<img src="https://user-images.githubusercontent.com/62037577/195869495-1c463300-636c-4730-b8df-a68a7308c7c4.png">
</p>
9. Repeat steps 6-8 for each sample in the run, then navigate to the GCP and upload the files.