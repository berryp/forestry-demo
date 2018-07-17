---
title: dsserver for content authors
---

# DSServer for Content Authors

In this wiki we will be discussing how the Dataquest system works and how
it relates to content authoring. This introduction is just a high level overview
and it doesn't cover ever technical concept. If you want a deeper dive into the
architecture, you can read more about it in the [`mainstack` repo](https://gitlab.dataquest.io/dataquestio/mainstack/).

We will also introduce some technical terms like workers, schedulers, servers,
and tools like Docker. For all these concepts, we will try our best to relate them
to their use for content authors. Regardless, you can read more about general server
architecture and the tools we use by following the links we will provide.

We will start off our dicussion with an overview of the architecture, then we will
dig a bit further into the content authoring specific parts. In the end, our
goal is to provide you, the author, with the knowledge and domain specific language
of the system as a whole. This will give you the tools to debug problems and the
ability to ask the right kind of questions when reporting a bug.

## Overview

The Dataquest system is a complex cluster of servers, running processes, and databases that
allows students to read content, write code, and test their solutions against answers
you, the content author, have written. The interface is divided into several different
isolated services that accomplish this goal. Here's a diagram of what the system
looks like:

<p align="center">
<img src="../images/system_architecture.svg">
</p>

Let's break down some of the parts a bit and describe them in more detail.

* **Frontend**: The frontend is the visual look of www.dataquest.io which is all the styling, interactions, and look of the website.
* **Backend API**: This is the meat of the whole interface. The backend web server, is a [Django app](https://www.djangoproject.com/) that responds to requests from the frontend and manipulates the data from the database to present it in a well structured data format. It also does the validation of setting data to the database and schedules jobs to the workers.
* **Postgres Database**: This is the main database for all of the dataquest data. This database contains user data, mission data, course data, and anything else relevant to the interface.
* **Redis**: Redis is a key-value store that we use for caching content and sending messages to workers. These messages are instructions that tell the workers what they should process.
* **Workers**: This services help the backend database by running seperate tasks that come in the form of messages from Redis. The types of tasks can be sending emails, running the code examples, and setting mission content to the database.

Each of the services are run inside their own isolated container, called a Docker container. Docker is a tool that we use which let's us create virtual machines that are configured to run each one of the services in their own environments. For more info on Docker, our lead engineer has written [a great overview](https://docs.google.com/document/d/1EbvCTpFZD_VLuIXfOBOyxSU3X3XbD-dczmG9SOT1TNU) on why we use it.

One awesome feature about Docker is that by running these services in their own virtual machines, they are easy to replicate in local development. Using a tool called `docker-compose` we can create a cluster of services, exactly like the diagram, in our local machine! This is incredibly powerful since we can develop on a local dataquest cluster that is very similar to our production cluster.

In `dscontent`, you may have been using a script `./dscontent` to invoke commands such as `up`, `down`, etc. These commands run `docker-compose` under the hood and spins a local cluster that we can develop on. Everytime you issue a command with `./dscontent`, you can visualize the diagram above as the system you are interacting with.

You might be wondering where the content stuff fits in all this. Well, for one, we do not have a content service running that serves the content live, so how does the content get shown on the website? We will now turn to an important feature of development cluster which is syncing the data.

## How Content Works with the System

When you develop content, you are usually doing a sequence of two things:

1. Writing the content in a jupyter notebook.
2. Syncing the content and checking how it looks on the interface.

Both of these steps are important to authoring content, but in this section we will be covering how (2) works within the Dataquest system.

### Running the Sync Command

Everytime you invoke the `./dscontent sync <mission number>` command, you are actually invoking a lot of hidden processes that work to display the content on the interface. Our goal in this section is to demystify that process at a mission level and then build up what happens when we call sync on all the missions. To start, let's discuss exactly what occurs when we run the command.

#### The Manager's Name is Django

When you issue the `sync` command, the first thing that happens is that Docker checks if the local cluster is running. If the local cluster is not running, then Docker starts up the cluster by waking up the backend, redis, workers, and postgres instance. For this command, we don't need the frontend since we are only running commands and not actually viewing the content just yet.

If all the services required are up and running, then we continue by running the `sync` command from the Django management script. As we mentioned in the overview, the backend service is a Django web app, a Python based webserver, and it has a handy feature called management commands which runs user defined commands on the backend service. If you want to see a list of these commands, you can run `./dscontent manage` and you will see what are available.

```shell
$ ./dscontent manage
Type 'manage.py help <subcommand>' for help on a specific subcommand.

Available subcommands:

[accounts]
    add_delighted_users
    add_group_premium
    add_premium
    add_subscribers_to_intercom
    assign_historical_discounts
    backfill_immediate_payments
    backfill_stripe_created_dates
    backfill_team_slack_invites
    clean_emails
    (...)
```

Therefore, when you run `./dscontent sync 123`, you are essentially running: `./dscontent manage sync_local_sources --mission 123`. This part is abstracted away to make running these reoccuring tasks even easier. After issuing the management command, the backend service then has to process the mission by requesting a worker to store the mission content in the database.

#### Workers: Seizing the Means of Sync Action

When the `sync` command is issued to the backend service, the backend then requests help of a worker to load the mission into the database. To request help from a worker, the backend web uses a tool called [Celery](http://www.celeryproject.org/) which manages the tasks and workers. Essentially, Celery does all the heavy lifting by abstracting away sending messages to Redis and running the workers to respond to those messages.

The steps involved are the following:
1. The backend web calls a Celery module to run the sync command for a certain mission.
2. The Celery module sends the message to Redis which waits for a worker to respond.
3. A Celery worker waiting for work responds to the Redis message and starts to process the message.
4. The worker then processes the sync and loads the content to the database.
5. Once completed, the worker awknowledges (acks) the task and states that is completed.

These 5 steps happen every time a `sync` command is issued. It might seem like a lot of work, but that's why we use Celery as a tool to abstract all the hard parts away. The real work that had to be written is in step 4 which we will detail next.

#### What Happens in the Sync??

In the 4th step, the process of the sync begins to take place. Here, the worker knows the mission number, knows which database to load the data into, and has the content to manipulate. The goal of the worker in this step is to strip away all the metadata from the Python mission notebook and using the `meta.yml` file load the appropriate info into the database.

First, the worker checks if the mission is included in the `course.yml` file and if the course is included in the `section.yml` files in the root of the `dscontent` folder. If not, it will automatically fail until you load the data in. Once you have added in the details, it will then sync the content.

All the details of the sync process can be found in the [`sync.py` file](https://gitlab.dataquest.io/dataquestio/mainstack/blob/master/server/missions/sync/__init__.py) in the `mainstack/server` repo. The high level overview is that the worker will add metadata using `meta.yml`, strip every screen from the python notebook, and then load the content plus code exercises in the database.

Using the `meta.yml`, the worker will create a mission Django model with the relevant metadata found in `meta.yml`. If the `meta.yml` is malformed, that is if it is missing some keys, then the sync job will fail. Always remember to include the required `meta.yml` keys in your mission directory.

Next, the sync task runs through the mission notebook. It requires that one and only one notebook exists with the title `Mission` is in the folder. Once it finds the notebook, it will iterate through the screens and start adding the content.

For every screen, you need to have the following:
1. Unique screen key.
2. Whether it is a `code` or `text` screen.
    * If it is a `code` screen then it requires the next screen to be a code exercise.
3. Concepts of the screen.
    * It will fail if it does not see any of the concepts in the `concepts/` directory.

Once all the screens pass those 3 validation checks, they are then created as Django models and added to the mission model. Depending on the screen type, there is also a code screen that can be added and will be run to ensure that it works as expected. Finally, the screens are saved and added to the database.

#### Running Sync on All the Directories

If you just run `./dscontent sync` without a mission number argument, then you will force Django to sync all the missions at once. This happens everytime you first create the Docker cluster. For this step, the management command just first a loop through all the directories and then does an incremental load starting from the first mission to the last.