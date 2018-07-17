---
title: Kubernetes
---

Kubernetes gives you a ton of information on the currently deployed services, and their status.  It's a good third place to look for application issues, after Sentry and Datadog.

With kubernetes, you can:

* Use the dashboard to see service information and logs
* Use kubectl to ssh into pods directly

## Dashboard

You can get to the dashboard [here](https://api.k8s.dataquest.io/ui)

### Namespace views

You start in the `default` namespace, but can change namespaces with the toggle on the left:

![](../images/kubernetes_namespaces.png)

In a single namespace, you can see all the deployed applications:

![](../images/kubernetes_applications.png)

### Single application

[Here's](https://api.k8s.dataquest.io/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard/#/deployment/prod/mainstack-web?namespace=prod) an example single application view.  After clicking on a single application, you can see information about CPU and memory usage:

![](../images/kubernetes_single_app.png)

By scrolling down and clicking on the replica set, then a single pod, you get to [this view](https://api.k8s.dataquest.io/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard/#/pod/prod/mainstack-web-2107297358-279rg?namespace=prod). 

From the single pod view, you can see container and pod logs:

![](../images/kubernetes_logs.png)

## Kubectl

Using kubectl, along with `kubectl get pods --namespace=prod`, you can list all the production pods:

![](../images/kubernetes_pods.png)

You can then ssh into a pod with `kubectl exec -it --namespace=prod POD_NAME -- /bin/bash`.


