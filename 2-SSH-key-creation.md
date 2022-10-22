---
layout: page
title: "SSH key creation"
permalink: /Wiki/SSH-key-creation/
categories: wiki
---

1.	To generate an SSH key, use the following command:
{% highlight ruby %}
ssh-keygen -t rsa
{% endhighlight %}

This will generate two keys, a public and private key. You can choose a location, or if you just hit enter on the prompt for where you want to save the key, it will save in the default location. You can also just hit enter for a passphrase if you do not want a passphrase (extra layer of security – not necessary).
 
> ![ssh_key](https://user-images.githubusercontent.com/62037577/195848068-ee674ffb-c439-4cc7-9bc7-b85a72ebc817.png)

2.	The generated key is now in the directory /home/lyr12/.ssh/. In that directory there is both a public (id_rsa.pub) and private (id_rsa) key. You can view this by typing ‘`ls .ssh/`’.
 
3.	The public key is the one that will be copied and put onto the genexus. To copy your public key, type ‘`cat .ssh/id_rsa.pub`’. You can then highlight the entire key (in my case, starting from ‘ssh-rsa’ and ending with ‘lyr12@HR19582’) and copy the key by holding down ‘ctrl’ + ‘c’. Do not close out of command prompt.
 
> ![cat_ssh](https://user-images.githubusercontent.com/62037577/195848110-16e0f632-5269-41b0-8c80-20c317888fa0.png)

4.	Open an internet browser (e.g., Google Chrome) and login to your genexus instrument. The URL will be the IP address of the genexus. One of the Wadsworth instruments will be used as an example (IP: 10.49.62.65). The following examples are in Google Chrome.
5.	In the URL bar, type in the IP address and hit enter. A screen will pop up saying that the connection is not private. In this case, click on ‘Advanced’ and then ‘Proceed to 10.49.62.65 (unsafe)’.
 
> ![connection](https://user-images.githubusercontent.com/62037577/195848128-91fc0676-a3fa-4b8d-b873-0d4417d5a153.png)

6.	Proceed to login to the instrument with your genexus username and password. It is recommended to login as the user ‘ionadmin’.
 
> ![login](https://user-images.githubusercontent.com/62037577/195848144-dc88def1-a24b-47a5-95a7-658aa55649c3.png)

7.	After logging in, look at the top right corner of the homepage and click on the person icon and then ‘My Profile’.
 
> ![homepage](https://user-images.githubusercontent.com/62037577/195848397-7b187152-8870-4320-adce-e39cd31deb85.png)

8.	On the ‘My Profile’ page you will see ‘+ Add SSH Key’ on the right. Click on that button. This is where you will paste the SSH key you had previously copied. If you do not still have the SSH key as the last copied item in your clipboard, return to the command prompt still open and copy it again. The ‘Label’ will be your name and the ‘SSH Key’ will be your entire public key. Click ‘Save’.
 
> ![add_ssh_key](https://user-images.githubusercontent.com/62037577/195848410-2c76d743-3755-4bae-9096-b429643d982b.png)

9.	Now return to your command prompt still open and proceed to WSL data retrieval and transfer.

Next page [WSL data retrieval and transfer](./WSL-data-retrieval-and-transfer.md)