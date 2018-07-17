---
title: Deployment Playbook
---


## Devops Playbook

This folder contains the devops playbook.  This playbook:

* Tells you what to do in a given devops scenario, such as when the server is down.
* Explains each of the tools in our kit, and what they do.
* Talks about how to message various incidents to students and the internal team.

## Tools

We use several tools to help diagnose errors.  They each have their own page in the playbook:

* [Sentry](tools/sentry/) -- good place to start, shows you all application errors across the frontend and backend.
* [Datadog](tools/datadog/) -- good second place to look, has tons of metrics on different pieces of the stack, as well as errors.
* [Scalyr](tools/scalyr/) -- good third place to look, has logs from all of our deployed services.
* [AWS Console](tools/aws_console/) -- a good place to look for infrastructure monitoring and to sanity check services.
* [Kubernetes](tools/kubernetes/) -- a good place to go to see which services are deployed currently, and to ssh into pods to perform operations directly.
* [Logrocket](tools/logrocket/) -- a good place to debug frontend errors.  Shows the full redux state store at various points, and allows you to watch user sessions.
* [Pingdom](tools/pingdom/) -- allows you to see uptime statistics for the site.
* [Front](tools/front/) -- a good place to view user messages, and identify symptoms of issues.  Also useful for asking for more context on problems.
* [Slack](tools/slack/) -- a good place to view user messages about their symptoms, and ask for more clarification.
* [Cloudflare](tools/cloudflare/) -- holds all of our DNS config, and automatically caches certain static routes.  A good place to go if you suspect a DNS/caching issue.

It's recommended to read through each tool page and familiarize yourself with the tool.  Each tool is helpful for debugging different types of issues, and you'll probably need to use them all at some point.

## Stack Layers

When there's an issue, it's useful to think of all the layers between a user sending a request and the response being returned:

```
Request
   v
Cloudflare (DNS)
   v
AWS elastic load balancer
   v
Kubernetes ingress controller
   v
Kubernetes ingress
   v
Kubernetes service
   v
Nginx server inside kubernetes pod for web server
   v
Daphne server inside kubernetes pod for web server
   v
Daphne workers inside kubernetes pod for web server (this actually processes the request)
   v
(Potentially) Elasticache, to retrieve a stored value
   v
AWS RDS (Database)
   v
(Potentially) Elasticache, to dump tasks into the celery queue
   v
(Potentially) Kubernetes pod for celery (delayed task runner)
   v
(Potentially) S3, to retrieve project data
   v
(Potentially) Docker container runner machine, to execute student code
   v
Response back to user
```

99% of the time, when the site is down, the issue will be in one of the above layers.  When you see downtime, make sure to think through all of these layers and look at monitoring to see which one is causing the problem.

## General Debugging

We'll outline a general debugging strategy before linking to more scenario-specific debugging strategies.  A good general heuristic is:

* Check Front and Slack to see if any users are experiencing the issue.  Read their comments for context.
* Check Logrocket.  You can watch user sessions to see what errors are occurring.  This can help give you more context, and start narrowing down what the actual issue is.
* Make sure to check Sentry for errors.  Sentry errors, [like this one](https://sentry.io/dataquest/web-prod/issues/285703940/), can be incredibly helpful for figuring out what's going on in the stack.  In particular, look for:
    * Errors that have occurred often recently.
    * Errors that just started occurring recently.
    * Any errors that seem tied to the symptoms users are experiencing.
* Check metrics and traces on Datadog.  For example, if the site is returning 500 errors, look at APM traces on Datadog to see what's going on.  These traces will tell you which pieces are running extra slow.  Useful Datadog views to look at are:
    * Infrastructure metrics, like RDS and EC2.
    * Any monitors that are in alarm states.
    * APM to check for errors or spikes in processing time for certain views.
* Check the Kubernetes dashboard to make sure all the services you expect are up and working.  It can be useful to look at the number of restarts for the pods in the deployment, plus CPU and memory usage.  You should check:
    * Each deployment that sits in the path of the user request being processed (mainstack-web, mainstack-celery, etc)/
    * The memory and CPU usage for each deployment
    * The logs for each deployment
* Check Scalyr for a deeper dive into the logs.  If a quick look at the logs in the Kubernetes dashboard shows that something is off, take a deeper look into the logs on Scalyr.
* Check the AWS console.  If timings indicate that there may be an infrastructure issue, then you should check all the components in the AWS console.
* If you still can't figure it out, you may need to manually SSH into the kubernetes pods and manually run shell commands to inspect database state.


## Scenarios

In this section, we'll break down what to do in various scenarios:

* [The frontend works, but the backend is down](scenarios/backend_down/) -- this usually manifests as students not being able to login, and hitting `dataquest.io` while logged in sending you to the home page instead of the dashboard (and you being treated like a logged out user).
* [The site doesn't load at all (no frontend)](scenarios/no_site/) -- this usually manifests as a completely blank page, or as an error.  Try hitting `dataquest.io` -- if you get nothing back, or a blank page, it's this.
* [The site works, but code running is down](scenarios/no_code_running/) -- this manifests as the dashboard loading fine, but code running appearing to take forever or time out.
* [The site works, but everything is slow](scenarios/site_slow/) -- this usually manifests as things working, just 2x-3x slower than normal.
* [Gitlab is down](scenarios/gitlab_down/) -- this usually manifests as Gitlab being inaccessible or slow.

## What To Do

If there's downtime, you should immediately investigate to see what the downtime is, and how pervasive it is:

* Check Slack and Front, and see what students are saying
* Check Logrocket to see the issue live
* Check Sentry to see any relevant errors
* Check Datadog APM to see relevant aggregate metrics

Once you've scoped out the issue roughly, you should message it internally:

* If it's out of your scope of understanding, figure out who to notify
* Notify someone who can handle CS and message the downtime to students
* Start a hangout so people can jump in and chat with you

After that, you should keep investigating and coordinate the response:

* Follow the scenario guides and general debugging guides to get a handle on the issue and figure out how to mitigate it
* Delegate pieces to others as you feel is appropriate

While you're responding:

* Make sure to update everyone on your status every 15 minutes
* Make sure to take a 5-10 minute break every 30 minutes