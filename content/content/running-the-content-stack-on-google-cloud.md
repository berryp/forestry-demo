---
title: Running the content stack on Google Cloud
---

**Creating a cloud instance**
- Request access from Srini to Google Cloud Platform.
- Create a Linux instance: of at least 7 gigabytes on [Google Compute Engine](https://console.cloud.google.com/compute/instances?project=dataquest-content-188718&authuser=1&duration=PT1H).
   - Select a flavor of Ubuntu with LTS (life time support).
   - Set the memory to be *at least* 7 gigabytes. 
   - Paste in your mac's public SSH key.
- Once there's a green check mark next to your instance, it means it's up and running.
- You can fire up a console right in the browser by clicking the **SSH** button under the **Connect** column.

**Basic Setup**
- Install :whale: :
   - [Install Docker CE (community edition) for Linux](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-docker-ce)
   - [Install Docker Compose for Linux](https://docs.docker.com/compose/install/) - make sure to click **Linux**
- Setup our content stack from Gitlab. Note that it will ask for your Gitlab username / password each time:
   - Clone `dscontent`: `git clone https://gitlab.dataquest.io/dataquestio/dscontent.git`
   - Clone `mainstack`: `git clone https://gitlab.dataquest.io/dataquestio/mainstack.git`
   - [How to save username / password](https://forum.gitlab.com/t/store-username-and-password/2547/2) so you don't have to login each time.
   - `cd dscontent`
   - `docker-compose up`

**VNC Setup**
- Comprehensive video on how to setup VNC for Ubuntu - https://www.youtube.com/watch?v=sT9JUL7q2uM
- Make sure to remember the password you set when setting up VNC server on Ubuntu on the cloud instance.

**How to use VNC**
- [Install VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/) locally for your operating system.
- Launch the terminal for your Google Cloud instance. From anywhere, run `vncserver -geometry 1600x1200`. You can change the resolution for improved VNC performance if you'd like.
- Open VNC viewer on your laptop / desktop. Type in the static IP + the port number for VNC and hit connect. For Jeff's instance, this is: `35.227.18.17:5901`. You'll be asked to type in your VNC server password from earlier.