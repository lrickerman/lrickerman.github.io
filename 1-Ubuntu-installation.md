---
layout: page
title: "Ubuntu installation"
permalink: /Wiki/Ubuntu-installation/
categories: wiki
---

1.	Open Command Prompt by pressing start or the Windows key and typing in ‘cmd’ in the search bar. Hit enter.
 
> ![command_prompt](https://user-images.githubusercontent.com/62037577/195848020-e372fbbe-fc5b-49f0-b381-d8b0f7e65b19.png)

2.	When command prompt opens, type in the following and hit enter:
{% highlight ruby %}
wsl --install -d ubuntu
{% endhighlight %}

3.	When installation is complete, type ‘`ubuntu`’ and hit enter.
 
> ![ubuntu](https://user-images.githubusercontent.com/62037577/195848050-1474e021-7a1f-413b-858b-f6e4d67ebb31.png)

4.	The title bar and header should now be your username and computer in the format [USER]@[HOST]. For example, my username is lyr12 and my computer, or host, is HR19582. This will change when logged into the genexus.


Next page  [SSH key creation](./SSH-key-creation.md).