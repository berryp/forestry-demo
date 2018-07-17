---
title: Datadog
---

We use datadog in five main ways:

* Datadog APM records how long different transactions, such as DB writes, redis writes, and server views, take to respond
* Datadog APM records application and underlying service errors
* Datadog has information on how long various stack components take to respond
* Datadog has information on uptime and other site reliability metrics
* Datadog monitors tell us when there's a problem with the site

Datadog monitors the backend and our infrastructure.  It tells us when something unexpected is happening, and gives us tools to debug.  This is almost always the second place you want to look when debugging, after [Sentry](../sentry/).

## Datadog APM

The datadog APM is application performance monitoring.  This is accessible [here](https://app.datadoghq.com/apm/home):

![](../images/datadog_apm.png)

The apm monitors celery (background) tasks, web (web servers), the database, and redis.  If you click into one, you get detailed information on that service:

![](../images/datadog_celery.png)

This information tells you the error rate, total time spent by service, and other valuable information.  For example, if a service suddenly spikes in time taken, there may be something blocking it.

This also breaks down the stats of each underlying function:

![](../images/datadog_resources.png)

If you click into a single function, you can see traces:

![](../images/datadog_function.png)

Clicking into a trace will give you detailed information on it:

![](../images/datadog_trace.png)

If you click into a SQL trace, you can see queries executed and timings.  Datadog APM can easily tell you if something is being blocked, or if there's a performance problem.

### Errors

You can also view just the traces [here](https://app.datadoghq.com/apm/search):

![](../images/datadog_errors.png)

You can break these down and filter by environment and error status.  This can be a handy way to find and debug errors.

## Datadog metrics

We can also use the [Datadog metric explorer](https://app.datadoghq.com/metric/explorer) to view various stack metrics.  One example is [viewing RDS writes](https://app.datadoghq.com/metric/explorer?live=true&page=0&is_auto=false&from_ts=1496618645364&to_ts=1496622245364&tile_size=m&exp_metric=aws.rds.write_iops&exp_scope=name%3Adsserverdb&exp_agg=avg&exp_row_type=metric):

![](../images/datadog_rds_writes.png)

These metrics allows you to quickly diagnose issues with specific parts of the stack.  These metrics range from EC2 metrics to K8s and Docker metrics to application-specific celery and web metrics.  Datadog integrations can be configured to get even more metrics.  I recommend scrolling through the metrics list to see everything that's available.

Metrics can be filtering on various tags, and added to dashboards or notebooks.  Metrics are a great way to explore stack performance.

## Datadog monitors

Datadog monitors trigger alarms based on metrics.  These alarms can be sent to PagerDuty.  You can see monitors [here](https://app.datadoghq.com/monitors/manage).  Monitors can be configured to report in different ways.  If you [click into a monitor](https://app.datadoghq.com/monitors#1612262?group=all&live=4h), you can see lots of configuration options.
