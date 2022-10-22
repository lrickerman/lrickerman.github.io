---
layout: page
title: "WSL data retrieval and transfer"
permalink: /Wiki/WSL-data-retrieval-transfer/
categories: wiki
---

## This tutorial is based on a Windows Subsystem for Linux (WSL). Examples and demonstration will be shown in Ubuntu. If you do not have a similar subsystem or terminal, or do not know what this means, please see the page on [Ubuntu installation](./Ubuntu-installation.md). Please note that WSL is required for this method of transfer. The other option is manual retrieval from the webpage.

### This requires use of an SSH key. If you do not have one, please see the [SSH key creation](./SSH-key-creation.md) page.

### **NOTE:** The following instructions will utilize personal information in examples. The fields that are personalized will be noted in the instructions – these are all fields that will need to be changed.

1. In your terminal, use the path to your private SSH key (**./.ssh/my_key**), instrument IP address (**10.49.62.65**), and instrument username (i.e., ionadmin) to login. You will need to know how many days ago the last run finished (i.e., 2 days ago, **-2**).

{% highlight ruby %}
ssh -T -i ./.ssh/my_key 10.49.62.65 -l ionadmin <<-EOF > tmp.txt
find /data/IR/data/analysis_output/ -type f -ctime -2 -name "*.ptrim.bam" -not -path "*block*" -print
EOF
grep -F '/data/IR' tmp.txt > log.txt
{% endhighlight %}

2. This creates a file consisting of the file paths for the most recent run. You can view this by typing `cat log.txt` if you want to make sure you found the files.

3. Next, you will download those files using the same SSH key (**./.ssh/my_key**) and instrument IP (**10.49.62.65**) and store them in the tmp directory. **NOTE:** When copying data, ~10GB+ per dataset is needed.

{% highlight ruby %}
while IFS= read -r line || [[ -n "$line" ]]; do s=$(echo $line | sed "s/.*ChipLane.*\/\(.*\)_LibPrep.*/\1/"); scp -q -i ./.ssh/my_key ionadmin@10.49.62.65:"$line" /tmp/nywws/$s.ptrim.bam; done < log.txt
{% endhighlight %}

4. After the files have downloaded, you will transfer them to the GCP folder for your location (**test**) and remove them from the tmp directory:

{% highlight ruby %}
gcloud storage cp -r /tmp/nywws/ gs://su_nywws_test_bucket/test
rm /tmp/nywws/*
{% endhighlight %}

**NOTE:** the GCP link will change - this will be updated once the new name is announced.