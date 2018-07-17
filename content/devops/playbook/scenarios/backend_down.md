---
title: Backend Down
---

The backend can be down for many reasons, which boil down to a few root causes:

* The daphne request queue is growing faster than it can be processed
* There's a DNS misconfiguration
* A component in the stack is down

## Request queue growing

By far the most common issue is the request queue growing too quickly.  This can be caused by:

* Daphne workers being blocked by an external resource, like the database or S3.
    * This happened when our RDS disk bandwidth was too low, so the disk queue depth kept growing.
    * This happened during the AWS outage when S3 reads/writes took a long time, and the save_project endpoint started blocking workers.
* Not having enough Daphne workers.
    * This happened when we were under heavy load last year.
* A DDOS or other type of attack (sometimes accidentaly)
    * This happened when the frontend kept spamming requests to the backend when a single user had multiple tabs open.

You can tell how long the request queue is by:

* Using `kubectl get pods --namespace=prod` to list production pods.
* Sshing into a `mainstack-web` pod with `kubectl exec -it --namespace=prod POD_NAME -- /bin/bash`.
* Running `redis-cli -n 4 -h dsserver-prod-004.tso1ep.0001.use1.cache.amazonaws.com -p 6379`
* Type `keys *` to see the number of keys in the redis queue.

Typically, the number should be low, and shouldn't keep increasing every time you run `keys *`.  If the number keeps increasing, you're probably running into the request queue issue.

You need to quickly determine if the workers are being blocked, or if the capacity is just too low.  You should:

* Spin up more `mainstack-web` pods by editing `apps/prod/mainstack/mainstack-web.yaml` to increase the number of replicas on line `7`, and the minReplicas on line `168`.
* Look into datadog APM to see which views are taking longer to process.  If it's all views, it's probably DB-related.
* Look into logs in Scalyr or the K8s dashboard to see if the workers are still processing requests.
* Check the number of hits per second in Datadog APM to make sure load is not significantly higher.

Once you know which resource is blocking, you need to take the appropriate steps to improve availability of that resource.  Some examples are:

* If the database is blocking, you should check DB CPU usage/memory/disk bandwidth.  If the CPU usage is high, you may need to upgrade the instance.  If the disk queue length is high, you may need to increase the size of the disk to get more IOPS.
* If an external service is blocking, you may need to make a quick patch to disable the view that uses that external service.

## DNS misconfiguration

This is relatively simple to fix with cloudflare.  Just try running a traceroute or dig on the path to see where it resolves first.  If it's not where you expect, check cloudflare.

## A component in the stack is down

You'll need to look at the kubernetes dashboard for this.  Make sure everything in the layer diagram of the stack is up.  Also check the AWS dashboard to make sure no servers are in an unexpected state.