---
title: AWS Console
---

The AWS console lets you see the status of our major infrastructure components.  With AWS, you can:

* See the status of our servers, databases, and caches
* Monitor memory and cpu usage for each of our components
* Take action to upgrade/downgrade/delete services

AWS is a good place to go once you've identified the issue, and want to confirm, or if you're really not sure and want to do a general survey of the infrastructure to see if anything is going wrong.

## Outage

AWS will sometimes have outages.  A good place to look for these is [here](https://status.aws.amazon.com/):

![](../images/aws_outages.png)

If there's an outage, you'll see the service listed above.

## Console

You can login to the AWS console [here](https://dataquest.signin.aws.amazon.com/console).  Logging into the console will allow you to access services, like EC2, RDS, and Elasticache.

By clicking into services, you can view monitoring information.  For example, here's the information for our production database:

![](../images/aws_rds.png)

## Different services

We leverage AWS quite a bit.  Here's a breakdown of each service we use:

* RDS -- production and stage databases
* Elasticache -- caches and celery queues for production/stage
* EC2 -- all servers (k8s cluster, container runners, gitlab runners)
* S3 -- storage of projects, content files, etc
* Route 53 -- DNS just for the k8s cluster
