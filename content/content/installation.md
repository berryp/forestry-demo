---
title: Installation
---

### Prerequisites

First, you'll need to install and verify Docker for Mac:

* Download the stable channel here, and follow the setup instructions -- https://docs.docker.com/docker-for-mac/
    * You'll need at least OSX 10.10.3 (latest version of Yosemite).  You may need to update.
* (Optional) Remove any older environment variables pointing to Docker Toolbox or Docker Machine
* (Optional) Adjust the memory allocated to Docker to 4GB or higher.
    * Search for "memory" on this page -- https://docs.docker.com/docker-for-mac/ -- to find out how.
* Run `docker ps` in the terminal, and verify that the command runs properly.  You should see something like this:

```
CONTAINER ID        IMAGE                                                             COMMAND                  CREATED             STATUS              PORTS
```

Next, we'll setup Gitlab and clone the dscontent repo:

* Setup your https credentials to store properly by following https://help.github.com/articles/caching-your-github-password-in-git/
* Clone the dsfrontend repo using `git clone https://gitlab.dataquest.io/dataquestio/dscontent.git`

We'll then need to setup a Docker Hub account and get the right permissions:

* Create an account at `https://hub.docker.com/`
* Ping someone with permissions (Vik) to get access to the Dataquest repositories
* Once you have permissions, run `docker login` on your machine to login to Docker.

### Setup

For the rest of the setup we have a handy script to get you up and running. If you have
followed the steps in prerequisites you should be good to go.

* In the `dscontent` directory, run `./dscontent setup`
    * This will take ~30 minutes to run so you'll need to be patient :)
* Once everything is setup, go to `localhost:3000`. You should see the development website running.
* Even after you can access the site, there are still some other setup tasks that will need to complete.  These will take ~45 more minutes.  Until these are done, you may have a blank dashboard, or see weird visual issues with the site.
* Once it is all set up, you should be able to login!
* You can add premium access to your account by running: `./dscontent manage add_premium <login email> 1000`
* To stop dscontent running, type `ctrl` + `c`

### Running dscontent

* To run dscontent, type `./dscontent up`.  A full content sync will need to take place (45-60min) before the backend comes up and you can login.  You can monitor this by running `./dscontent logs -f`

For more, read [getting started](../getting-started).



