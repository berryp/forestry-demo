---
title: Site slow
---

You should look at the docs for [backend down](../backend_down/) and [no code running](../no_code_running/), since site slowness can be caused by the same issues mentioned in those docs.

Some additional causes of the site being slow are:

* Database is under heavy load
* There's a traffic spike

## Database under heavy load

You can verify this scenario by looking at the AWS console.  If the database is under heavy load, you'll see the CPU utilization, memory utilization, and/or disk queue depth be high.

In this scenario, you can:

* Restart the database server from the AWS console
* Investigate any changes in a recent deploy that would cause DB load
* Increase the instance size of the DB server

## Traffic spike

It can be hard to deal with a load spike, but the best way to do it is to increase the number of web and celery containers that we have running.  You should also investigate any recent deploys to make sure we're not DDOSing ourselves.  Other mitigation strategies are:

* Patches to the backend to throttle certain endpoints
* Looking into any blocking resources to make sure the issue isn't further upstream
* Increasing our cluster size to handle more pods