---
title: Gitlab down
---

Gitlab being down or slow can be caused by a few different issues:

* The gitlab data EBS volume is full, or being utilized too heavily
* Gitlab containers are using too much memory/CPU
* The Gitlab database is under too much load

To mitigate these issues, you'll need to investigate the components in the Gitlab stack:

* EBS for repo data storage
* EFS for config data storage
* RDS for operational data storage
* In-instance queue for delayed tasks
* In-instance nginx

In this case, it's helpful to look at the logs on Scalyr, and the monitoring for the components on Datadog/AWS console.

It's also helpful to read the Gitlab docs on [debugging](https://docs.gitlab.com/ce/administration/troubleshooting/debug.html).  Most of these can be accessed using `kubectl` to ssh into the gitlab instance.

You can also do [request profiling](https://docs.gitlab.com/ee/administration/monitoring/performance/request_profiling.html) on Gitlab to see why things are slow.