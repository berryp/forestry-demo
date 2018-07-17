---
title: No site
---

The whole site being down can be one of a few issues:

* DNS misconfiguration
* Frontend pod not up
* Stack component is down

## DNS misconfiguration

Check cloudflare, and make sure everything is setup properly.  Make sure the elastic load balancer that's specified in cloudflare actually exists in the AWS console.

Try clearing the cloudflare cache (purge everything), as this might cause cloudflare to re-fetch the correct files from the frontend pod.

## Frontend pod not up

Check the kubernetes dashboard, and make sure the frontend deployment, ingress, and service are all up.  It can be worth rolling back versions if this error happened on deployment.

## Stack component is down

Check to ensure that the kubernetes cluster is up (try the dashboard).  Ensure requests for other pieces of the stack, like `sandbox.dataquest.io`, and `metabase.dataquest.io` are routed properly.  If a stack component is missing, make sure to redeploy it from this repo.